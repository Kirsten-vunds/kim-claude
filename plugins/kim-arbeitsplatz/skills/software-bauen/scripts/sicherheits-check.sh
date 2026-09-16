#!/usr/bin/env bash
# Prueft ein Projekt auf die Fehler, an denen KI-gebaute Software regelmaessig scheitert.
# Aendert nichts. Ausgabe: STUFE|Titel|Detail  (ROT / GELB / GRUEN)
# Aufruf: sicherheits-check.sh [--url https://...]
set -u

URL=""
[ "${1:-}" = "--url" ] && URL="${2:-}"

rot()   { echo "ROT|$1|$2"; }
gelb()  { echo "GELB|$1|$2"; }
gruen() { echo "GRUEN|$1|$2"; }

IN_GIT=0; git rev-parse --is-inside-work-tree >/dev/null 2>&1 && IN_GIT=1
if [ $IN_GIT -eq 1 ]; then
  DATEIEN="$(git ls-files 2>/dev/null)"
else
  DATEIEN="$(find . -type f \
    -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/.venv/*' \
    -not -path '*/venv/*' -not -path '*/dist/*' -not -path '*/build/*' 2>/dev/null)"
fi

echo "== 1. Zugangsdaten im Code =="
MUSTER='sk-ant-api[0-9]{2}-|sk-[A-Za-z0-9]{32,}|AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{22,}|AIza[0-9A-Za-z_-]{35}|xoxb-[0-9A-Za-z-]{10,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|service_role'
AUSSCHLUSS='sicherheits-check\.sh$|umgebung-pruefen\.sh$|\.env\.beispiel$|\.env\.example$|package-lock\.json$|yarn\.lock$|\.min\.js$|\.map$|\.lock$'
LISTE="$(printf '%s\n' "$DATEIEN" | grep -vE "$AUSSCHLUSS" 2>/dev/null || true)"
TREFFER=""
if [ -n "$LISTE" ]; then
  TREFFER="$(printf '%s\n' "$LISTE" | while IFS= read -r f; do
    [ -f "$f" ] && grep -InE "$MUSTER" -- "$f" 2>/dev/null | head -3 | sed "s|^|$f:|"
  done)"
fi
if [ -n "$TREFFER" ]; then
  printf '%s\n' "$TREFFER" | while IFS= read -r t; do
    rot "Zugangsdaten stehen im Code" "$(printf '%s' "$t" | cut -c1-160)"
  done
else
  gruen "Keine Zugangsdaten im Code gefunden" "Muster fuer gaengige API-Schluessel geprueft"
fi

echo "== 2. .gitignore und .env =="
if [ -f .gitignore ]; then
  grep -qE '^\.env' .gitignore && gruen ".env ist von Git ausgeschlossen" "" \
    || rot ".env fehlt in .gitignore" "Zugangsdaten wuerden beim Hochladen mitgehen"
else
  [ $IN_GIT -eq 1 ] && rot "Keine .gitignore vorhanden" "Alles wuerde mit hochgeladen" \
                    || gelb "Keine .gitignore vorhanden" "Noch kein Git-Projekt"
fi
if [ $IN_GIT -eq 1 ] && git ls-files --error-unmatch .env >/dev/null 2>&1; then
  rot ".env liegt bereits in der Versionsverwaltung" "Schluessel gelten als kompromittiert - neu ausstellen"
fi

echo "== 3. Geheimnisse im Browser-Teil =="
FRONT="$(printf '%s\n' "$DATEIEN" | grep -E '^(\./)?(src|app|client|public|components|pages)/' 2>/dev/null || true)"
FTREFFER=""
if [ -n "$FRONT" ]; then
  FTREFFER="$(printf '%s\n' "$FRONT" | while IFS= read -r f; do
    [ -f "$f" ] && grep -InE "service_role|SERVICE_ROLE|SECRET_KEY|PRIVATE_KEY|$MUSTER" -- "$f" 2>/dev/null | head -2 | sed "s|^|$f:|"
  done)"
fi
if [ -n "$FTREFFER" ]; then
  printf '%s\n' "$FTREFFER" | while IFS= read -r t; do
    rot "Geheimnis im Browser-Teil" "$(printf '%s' "$t" | cut -c1-160)"
  done
else
  gruen "Keine Geheimnisse im Browser-Teil" "Was im Browser laeuft, kann jeder Besucher lesen"
fi

echo "== 4. Zugriffsschutz der Datenbank =="
if grep -rlE 'supabase|createClient' --include='*.ts' --include='*.js' --include='*.tsx' --include='*.jsx' . 2>/dev/null \
   | grep -v node_modules | head -1 | grep -q .; then
  # Tabellen und abgesicherte Tabellen einzeln zaehlen - ein einziges Vorkommen
  # von "enable row level security" sagt nichts ueber die uebrigen Tabellen aus.
  SQL="$(printf '%s\n' "$DATEIEN" | grep -iE '\.sql$' 2>/dev/null || true)"
  TABELLEN=""; GESCHUETZT=""
  if [ -n "$SQL" ]; then
    TABELLEN="$(printf '%s\n' "$SQL" | while IFS= read -r f; do
      [ -f "$f" ] && grep -ioE 'create +table +(if +not +exists +)?["a-zA-Z0-9_.]+' -- "$f" 2>/dev/null \
        | sed -E 's/.*[ ."]([a-zA-Z0-9_]+)"?$/\1/' | tr 'A-Z' 'a-z'
    done | sort -u | grep -v '^$' || true)"
    GESCHUETZT="$(printf '%s\n' "$SQL" | while IFS= read -r f; do
      [ -f "$f" ] && grep -ioE 'alter +table +["a-zA-Z0-9_.]+ +enable +row +level +security' -- "$f" 2>/dev/null \
        | sed -E 's/alter +table +//I; s/ +enable.*//I; s/.*[."]([a-zA-Z0-9_]+)"?$/\1/; s/"//g' | tr 'A-Z' 'a-z'
    done | sort -u | grep -v '^$' || true)"
  fi
  ANZ_T="$(printf '%s\n' "$TABELLEN" | grep -c . 2>/dev/null || echo 0)"
  ANZ_G="$(printf '%s\n' "$GESCHUETZT" | grep -c . 2>/dev/null || echo 0)"
  if [ "${ANZ_T:-0}" -gt 0 ] 2>/dev/null; then
    # comm statt grep -vxF: grep liefert Exit 1, wenn NICHTS uebrig bleibt -
    # ein "|| alle Tabellen"-Fallback drehte damit genau den guten Fall auf Rot.
    OFFEN="$(comm -23 \
      <(printf '%s\n' "$TABELLEN"   | grep -v '^$' | sort -u) \
      <(printf '%s\n' "$GESCHUETZT" | grep -v '^$' | sort -u) 2>/dev/null)"
    if [ -n "$(printf '%s' "$OFFEN" | tr -d '[:space:]')" ]; then
      rot "Tabellen ohne Zeilenschutz: $(printf '%s' "$OFFEN" | tr '\n' ' ')" \
          "$ANZ_G von $ANZ_T Tabellen haben Row Level Security - die uebrigen sind ueber die oeffentliche Schnittstelle abrufbar"
    else
      gruen "Alle $ANZ_T Tabellen haben Zeilenschutz" "Row Level Security je Tabelle gefunden - Regeln trotzdem mit dem anon key gegenpruefen"
    fi
  elif grep -rlE 'enable row level security|ENABLE ROW LEVEL SECURITY' . 2>/dev/null | grep -v node_modules | head -1 | grep -q .; then
    gelb "Zeilenschutz gefunden, aber nicht nachzaehlbar" "Keine .sql-Dateien im Projekt - im Supabase-Dashboard pruefen, ob JEDE Tabelle RLS hat"
  else
    rot "Datenbank ohne Zeilenschutz" "Supabase im Einsatz, aber keine Row-Level-Security-Regeln gefunden - Tabellen sind ggf. frei abrufbar"
  fi
fi

echo "== 4b. Echte Daten in der Versionsverwaltung =="
if [ $IN_GIT -eq 1 ]; then
  DAT="$(git ls-files 2>/dev/null | grep -iE '\.(csv|xlsx|xls|sqlite|db|json)$' | grep -viE 'package(-lock)?\.json|tsconfig|composer|beispiel|example|sample|test' | head -5)"
  if [ -n "$DAT" ]; then
    printf '%s\n' "$DAT" | while IFS= read -r d; do
      gelb "Datendatei liegt in der Versionsverwaltung" "$d - falls echte Personendaten drin sind, gehoert sie nach daten/"
    done
  else
    gruen "Keine Datendateien in der Versionsverwaltung" "echte Daten gehoeren nach daten/"
  fi
  if [ -d daten ] && ! grep -q '^daten/' .gitignore 2>/dev/null; then
    rot "Ordner daten/ ist nicht von Git ausgeschlossen" "Echte Daten wuerden mit hochgeladen"
  fi
fi

echo "== 4c. KI-Routen: Anmeldung, Begrenzung, Eingabelaenge =="
KIDATEIEN="$(printf '%s\n' "$DATEIEN" | while IFS= read -r f; do
  [ -f "$f" ] && grep -lIE 'anthropic|openai|generativeai|\bmistral|messages\.create|chat\.completions' -- "$f" 2>/dev/null
done | grep -vE 'node_modules|sicherheits-check\.sh|\.md$|package(-lock)?\.json' || true)"
if [ -n "$(printf '%s' "$KIDATEIEN" | tr -d '[:space:]')" ]; then
  FEHLT=""
  printf '%s\n' "$KIDATEIEN" | grep -qE '.' && {
    grep -lIE 'getUser|getSession|auth\.|requireAuth|verifyToken|currentUser|session' $(printf '%s\n' "$KIDATEIEN") >/dev/null 2>&1 || FEHLT="$FEHLT Anmeldung"
    grep -lIE 'rate.?limit|ratelimit|Ratelimit|slowDown|throttle' $(printf '%s\n' "$KIDATEIEN") >/dev/null 2>&1 || FEHLT="$FEHLT Begrenzung-pro-Nutzer"
    grep -lIE 'max_tokens|maxTokens|\.length *[<>]|slice\(0,|substring\(0,|z\.string\(\)\.max' $(printf '%s\n' "$KIDATEIEN") >/dev/null 2>&1 || FEHLT="$FEHLT Eingabelaenge"
  }
  if [ -n "$FEHLT" ]; then
    rot "KI-Aufruf ohne$FEHLT" "Ein offener Endpunkt mit KI-Schluessel laeuft auf eure Rechnung - Anmeldung, Begrenzung pro Nutzer und Laengengrenze gehoeren an jede solche Route"
  else
    gruen "KI-Routen abgesichert" "Anmeldung, Begrenzung und Laengengrenze gefunden - Tageslimit im Anbieterkonto zusaetzlich pruefen"
  fi
fi

echo "== 4c2. Dateiablage und Antwortfelder =="
STORD="$(printf '%s\n' "$DATEIEN" | while IFS= read -r f; do
  [ -f "$f" ] && grep -lIE 'storage\.from\(|createBucket|storage/v1/object|getPublicUrl|S3Client|put_object' -- "$f" 2>/dev/null
done | grep -vE 'node_modules|sicherheits-check\.sh|\.md$|package(-lock)?\.json|\.min\.js$' || true)"
if [ -n "$(printf '%s' "$STORD" | tr -d '[:space:]')" ]; then
  OFFENB="$(printf '%s\n' "$STORD" | while IFS= read -r f; do
    grep -InE 'public *: *true|storage/v1/object/public|getPublicUrl' -- "$f" 2>/dev/null | head -2 | sed "s|^|$f:|"
  done)"
  if [ -n "$(printf '%s' "$OFFENB" | tr -d '[:space:]')" ]; then
    printf '%s\n' "$OFFENB" | while IFS= read -r b; do
      rot "Dateiablage ist oeffentlich" "$(printf '%s' "$b" | cut -c1-160) - hochgeladene Dateien sind dann ohne Login ueber ihre Adresse abrufbar; Bucket auf privat und mit zeitlich begrenzten Links ausliefern"
    done
  elif printf '%s\n' "$STORD" | xargs grep -lIE 'createSignedUrl|signed_url|presigned' >/dev/null 2>&1; then
    gruen "Dateien werden ueber begrenzte Links ausgeliefert" "Zugriffsregeln je Bucket trotzdem im Dashboard pruefen"
  else
    gelb "Dateiablage im Einsatz, Zugriffsregeln nicht erkennbar" "Pruefen: Bucket auf privat, eigene Regeln je Bucket, Auslieferung ueber zeitlich begrenzte Links"
  fi
fi
SELECTALL="$(printf '%s\n' "$DATEIEN" | grep -E '(api|route|server|handler|controller)' 2>/dev/null | while IFS= read -r f; do
  [ -f "$f" ] && grep -InE "\.select\( *[\"'\`]\*|SELECT +\* +FROM" -- "$f" 2>/dev/null | head -2 | sed "s|^|$f:|"
done | grep -vE 'node_modules|\.min\.js$' || true)"
if [ -n "$(printf '%s' "$SELECTALL" | tr -d '[:space:]')" ]; then
  printf '%s\n' "$SELECTALL" | while IFS= read -r s; do
    gelb "Schnittstelle gibt alle Spalten zurueck" "$(printf '%s' "$s" | cut -c1-160) - die Antwort ist im Browser lesbar; nur die Felder aufzaehlen, die die Ansicht braucht"
  done
fi

echo "== 4d. Wer von aussen anfragen darf (CORS) =="
CORSD="$(printf '%s\n' "$DATEIEN" | while IFS= read -r f; do
  [ -f "$f" ] && grep -lIE 'Access-Control-Allow-Origin|cors\(|CORSMiddleware|allow_origins' -- "$f" 2>/dev/null
done | grep -vE 'node_modules|sicherheits-check\.sh|\.md$|package(-lock)?\.json|\.min\.js$' || true)"
if [ -n "$(printf '%s' "$CORSD" | tr -d '[:space:]')" ]; then
  OFFEN_CORS="$(printf '%s\n' "$CORSD" | while IFS= read -r f; do
    grep -InE "Access-Control-Allow-Origin[\"' ]*[,:] *[\"']\*|allow_origins *= *\[ *[\"']\*|origin: *[\"']\*" -- "$f" 2>/dev/null | head -2 | sed "s|^|$f:|"
  done)"
  NACKT="$(printf '%s\n' "$CORSD" | while IFS= read -r f; do
    grep -InE 'app\.use\(cors\(\)\)|cors\(\) *\)' -- "$f" 2>/dev/null | head -1 | sed "s|^|$f:|"
  done)"
  if [ -n "$(printf '%s' "$OFFEN_CORS" | tr -d '[:space:]')" ]; then
    printf '%s\n' "$OFFEN_CORS" | while IFS= read -r c; do
      rot "CORS steht auf * - jede fremde Seite darf anfragen" "$(printf '%s' "$c" | cut -c1-160)"
    done
  elif [ -n "$(printf '%s' "$NACKT" | tr -d '[:space:]')" ]; then
    printf '%s\n' "$NACKT" | while IFS= read -r c; do
      rot "CORS ohne Einschraenkung eingeschaltet" "$(printf '%s' "$c" | cut -c1-160) - cors() ohne origin-Angabe erlaubt jede Herkunft"
    done
  else
    gruen "CORS ist eingeschraenkt" "Keine Freigabe fuer jede Herkunft gefunden"
  fi
fi

echo "== 4e. Sitzung und Cookies =="
LSTREFFER="$(printf '%s\n' "$DATEIEN" | while IFS= read -r f; do
  [ -f "$f" ] && grep -InE 'localStorage\.setItem\( *[\"'\''`][^\"'\''`]*(token|jwt|session|auth|key)' -- "$f" 2>/dev/null | head -2 | sed "s|^|$f:|"
done | grep -vE 'node_modules|\.min\.js$' || true)"
if [ -n "$(printf '%s' "$LSTREFFER" | tr -d '[:space:]')" ]; then
  printf '%s\n' "$LSTREFFER" | while IFS= read -r l; do
    gelb "Anmelde-Token im Browser-Speicher" "$(printf '%s' "$l" | cut -c1-160) - aus localStorage kann eingeschleuster Fremdcode es auslesen; besser httpOnly-Cookie"
  done
fi
COOKIED="$(printf '%s\n' "$DATEIEN" | while IFS= read -r f; do
  [ -f "$f" ] && grep -lIE 'res\.cookie\(|cookies\(\)\.set\(|set_cookie|setHeader\([\"'\'']Set-Cookie' -- "$f" 2>/dev/null
done | grep -vE 'node_modules|sicherheits-check\.sh|\.md$|\.min\.js$' || true)"
if [ -n "$(printf '%s' "$COOKIED" | tr -d '[:space:]')" ]; then
  if grep -lIE 'httpOnly|httponly|HttpOnly' $(printf '%s\n' "$COOKIED") >/dev/null 2>&1; then
    gruen "Cookies werden mit httpOnly gesetzt" "secure und sameSite zusaetzlich pruefen"
  else
    rot "Cookie ohne httpOnly gesetzt" "$(printf '%s\n' "$COOKIED" | head -1) - ein Anmelde-Cookie ohne httpOnly, secure und sameSite ist auslesbar und geht bei fremden Anfragen mit"
  fi
fi

echo "== 4f. Geld und Rueckmeldungen fremder Dienste =="
ZAHLD="$(printf '%s\n' "$DATEIEN" | while IFS= read -r f; do
  [ -f "$f" ] && grep -lIE 'stripe|paypal|mollie|checkout\.session|paymentIntent' -- "$f" 2>/dev/null
done | grep -vE 'node_modules|sicherheits-check\.sh|\.md$|package(-lock)?\.json|\.min\.js$' || true)"
if [ -n "$(printf '%s' "$ZAHLD" | tr -d '[:space:]')" ]; then
  BETRAG="$(printf '%s\n' "$ZAHLD" | while IFS= read -r f; do
    grep -InE '(amount|unit_amount|price|betrag|preis)[^=]{0,20}(req\.body|request\.body|body\.|params\.|searchParams|req\.query)' -- "$f" 2>/dev/null | head -2 | sed "s|^|$f:|"
  done)"
  if [ -n "$(printf '%s' "$BETRAG" | tr -d '[:space:]')" ]; then
    printf '%s\n' "$BETRAG" | while IFS= read -r b; do
      rot "Betrag kommt aus der Anfrage" "$(printf '%s' "$b" | cut -c1-160) - Preis und Menge gehoeren serverseitig aus den eigenen Daten, sonst ist der Betrag manipulierbar"
    done
  else
    gruen "Kein Betrag aus der Anfrage uebernommen" "Preise werden offenbar serverseitig bestimmt"
  fi
fi
WEBHOOKD="$(printf '%s\n' "$DATEIEN" | while IFS= read -r f; do
  [ -f "$f" ] && grep -lIE 'webhook' -- "$f" 2>/dev/null
done | grep -vE 'node_modules|sicherheits-check\.sh|\.md$|package(-lock)?\.json|\.min\.js$|\.env' || true)"
if [ -n "$(printf '%s' "$WEBHOOKD" | tr -d '[:space:]')" ]; then
  if grep -lIE 'constructEvent|verifySignature|verify_signature|svix|createHmac|hmac|timingSafeEqual|compare_digest' $(printf '%s\n' "$WEBHOOKD") >/dev/null 2>&1; then
    gruen "Webhook prueft die Signatur" "Zusaetzlich pruefen, dass dieselbe Meldung nur einmal verarbeitet wird"
  else
    rot "Webhook ohne Signaturpruefung" "$(printf '%s\n' "$WEBHOOKD" | head -1) - die Adresse kann jeder kennen; ohne Signaturpruefung kann jeder z.B. eine Zahlung melden, die nie stattfand"
  fi
fi

echo "== 5. Abhaengigkeiten =="
if [ -f package.json ] && command -v npm >/dev/null 2>&1; then
  A="$(npm audit --omit=dev --json 2>/dev/null || true)"
  H="$(printf '%s' "$A" | grep -o '"high":[0-9]*' | head -1 | cut -d: -f2)"
  C="$(printf '%s' "$A" | grep -o '"critical":[0-9]*' | head -1 | cut -d: -f2)"
  H="${H:-0}"; C="${C:-0}"
  if [ "${C}" -gt 0 ] 2>/dev/null; then rot "$C kritische Luecken in Fremdbibliotheken" "npm audit fix"
  elif [ "${H}" -gt 0 ] 2>/dev/null; then gelb "$H schwere Luecken in Fremdbibliotheken" "npm audit fix"
  else gruen "Fremdbibliotheken ohne bekannte schwere Luecken" ""; fi
fi

echo "== 6. Erreichbarkeit von aussen =="
if [ -n "$URL" ] && command -v curl >/dev/null 2>&1; then
  BASIS="${URL%/}"
  for PFAD in "/api/users" "/api/data" "/api/admin" "/rest/v1/" "/.env" "/api" \
              "/api/chat" "/api/ai" "/api/generate" "/api/completion"; do
    CODE="$(curl -s -o /tmp/sb_body.$$ -w '%{http_code}' -m 8 "$BASIS$PFAD" 2>/dev/null || echo 000)"
    GROESSE="$(wc -c < /tmp/sb_body.$$ 2>/dev/null | tr -d ' ')"
    if [ "$CODE" = "200" ] && [ "${GROESSE:-0}" -gt 40 ]; then
      if grep -qE '"(email|password|token|id)"|BEGIN|=' /tmp/sb_body.$$ 2>/dev/null; then
        rot "Ohne Login erreichbar: $PFAD" "Antwortet mit Daten (HTTP 200, ${GROESSE} Bytes)"
      else
        gelb "Ohne Login erreichbar: $PFAD" "HTTP 200, ${GROESSE} Bytes - pruefen was da rauskommt"
      fi
    fi
    rm -f /tmp/sb_body.$$ 2>/dev/null
  done
  for KIPFAD in "/api/chat" "/api/ai" "/api/generate" "/api/completion"; do
    KCODE="$(curl -s -o /tmp/sb_ki.$$ -w '%{http_code}' -m 15 -X POST \
      -H 'Content-Type: application/json' -d '{"messages":[{"role":"user","content":"hi"}],"prompt":"hi"}' \
      "$BASIS$KIPFAD" 2>/dev/null || echo 000)"
    if [ "$KCODE" = "200" ]; then
      rot "KI-Endpunkt ohne Login nutzbar: $KIPFAD" "Antwortet auf eine Anfrage ohne Anmeldung - jeder kann auf eure Rechnung Modelle aufrufen"
    fi
    rm -f /tmp/sb_ki.$$ 2>/dev/null
  done
  CH="$(curl -s -I -m 8 "$BASIS" 2>/dev/null | tr 'A-Z' 'a-z')"
  printf '%s' "$CH" | grep -q 'strict-transport-security' \
    && gruen "Verschluesselte Verbindung erzwungen" "" \
    || gelb "HTTPS wird nicht erzwungen" "Ohne HSTS-Header koennen Daten im Klartext gehen"
  echo "$BASIS" | grep -q '^https://' || rot "Adresse laeuft ohne Verschluesselung" "http:// statt https://"
else
  [ -z "$URL" ] && echo "HINWEIS|Kein Aussentest gelaufen|Mit --url <adresse> aufrufen, sobald die Anwendung erreichbar ist"
fi

echo "== ENDE =="
