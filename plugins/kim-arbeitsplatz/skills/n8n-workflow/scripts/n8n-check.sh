#!/usr/bin/env bash
# Introspektion einer n8n-Instanz OHNE SSH — nur mit Public-API-Key.
# Für Kunden-Instanzen (z. B. Guidant), auf die wir keinen Shell-Zugang haben.
#
# Nutzung:
#   n8n-check.sh                         # nimmt $N8N_API_URL / $N8N_API_KEY
#   n8n-check.sh <api-url> <api-key>     # explizit, api-url MIT /api/v1
#   N8N_UI_USER=… N8N_UI_PASSWORD=… n8n-check.sh …   # zusätzlich volle Node-Type-Liste
#
# Ausgabe: n8n-Version, API-Erreichbarkeit, und die auf DIESER Instanz real
# verwendeten Node-Typen samt typeVersion (aus bestehenden Workflows abgeleitet).
set -uo pipefail

API_URL="${1:-${N8N_API_URL:-}}"
API_KEY="${2:-${N8N_API_KEY:-}}"

if [[ -z "$API_URL" || -z "$API_KEY" ]]; then
  echo "FEHLER: API-URL und API-Key nötig (Argumente oder \$N8N_API_URL/\$N8N_API_KEY)." >&2
  exit 2
fi

API_URL="${API_URL%/}"
BASE="${API_URL%/api/v1}"

hr() { printf '\n=== %s ===\n' "$1"; }

hr "Instanz"
echo "Base : $BASE"
echo "API  : $API_URL"

# --- 0. UI-Login (optional) -------------------------------------------------
# Nur mit Session-Cookie liefert /rest/settings die Version (settingsMode=public
# ist beschnitten) und /rest/node-types die volle Node-Liste.
COOKIE_JAR=""
if [[ -n "${N8N_UI_USER:-}" && -n "${N8N_UI_PASSWORD:-}" ]]; then
  COOKIE_JAR="$(mktemp)"
  trap 'rm -f "$COOKIE_JAR"' EXIT
  LOGIN_CODE="$(curl -sS --max-time 20 -o /dev/null -w '%{http_code}' \
    -c "$COOKIE_JAR" -X POST "$BASE/rest/login" \
    -H 'Content-Type: application/json' \
    -d "$(jq -n --arg e "$N8N_UI_USER" --arg p "$N8N_UI_PASSWORD" \
          '{emailOrLdapLoginId:$e, password:$p}')" 2>/dev/null)"
  if [[ "$LOGIN_CODE" == "200" ]]; then
    echo "UI-Login: OK"
  else
    echo "UI-Login: fehlgeschlagen (HTTP $LOGIN_CODE)"
    rm -f "$COOKIE_JAR"; COOKIE_JAR=""
  fi
fi

# --- 1. n8n-Version ---------------------------------------------------------
settings() {
  if [[ -n "$COOKIE_JAR" ]]; then
    curl -fsS --max-time 20 -b "$COOKIE_JAR" "$BASE/rest/settings" 2>/dev/null
  else
    curl -fsS --max-time 20 "$BASE/rest/settings" 2>/dev/null
  fi
}
SETTINGS="$(settings)"
VERSION="$(jq -r '.data.versionCli // .data.version // empty' <<<"$SETTINGS" 2>/dev/null)"
if [[ -n "${VERSION:-}" ]]; then
  echo "n8n-Version: $VERSION"
else
  echo "n8n-Version: NICHT ermittelbar — /rest/settings antwortet im"
  echo "             beschnittenen public-Modus (kein versionCli ohne Login)."
  echo "             → N8N_UI_USER/N8N_UI_PASSWORD setzen ODER Version beim Kunden erfragen"
  echo "               (n8n-UI: Hilfe-Menü → About / unten links)."
fi

# --- 2. API-Erreichbarkeit --------------------------------------------------
hr "Public API"
WF_JSON="$(curl -sS --max-time 30 -w '\n%{http_code}' \
  -H "X-N8N-API-KEY: $API_KEY" \
  "$API_URL/workflows?limit=250" 2>/dev/null)"
HTTP_CODE="$(tail -n1 <<<"$WF_JSON")"
WF_BODY="$(sed '$d' <<<"$WF_JSON")"

case "$HTTP_CODE" in
  200) echo "GET /workflows: OK (200)" ;;
  401) echo "GET /workflows: 401 — Key falsch, abgelaufen oder für andere Instanz"; exit 1 ;;
  404) echo "GET /workflows: 404 — Public API deaktiviert? (N8N_PUBLIC_API_DISABLED) oder falscher Pfad"; exit 1 ;;
  *)   echo "GET /workflows: HTTP $HTTP_CODE"; echo "$WF_BODY" | head -c 500; exit 1 ;;
esac

WF_COUNT="$(jq -r '.data | length' <<<"$WF_BODY" 2>/dev/null || echo 0)"
echo "Workflows auf der Instanz: $WF_COUNT"

# Credentials (zeigt, welche Integrationen der Kunde schon eingerichtet hat)
CRED="$(curl -sS --max-time 20 -H "X-N8N-API-KEY: $API_KEY" "$API_URL/credentials" 2>/dev/null)"
if jq -e '.data' >/dev/null 2>&1 <<<"$CRED"; then
  hr "Vorhandene Credentials (ID | Typ | Name)"
  jq -r '.data[] | "\(.id) | \(.type) | \(.name)"' <<<"$CRED"
else
  echo "GET /credentials: nicht verfügbar (in dieser n8n-Version normal)"
fi

# --- 3. typeVersions aus bestehenden Workflows ------------------------------
# Der verlässlichste SSH-freie Weg: was auf dieser Instanz schon läuft, ist gültig.
hr "Real verwendete Node-Typen + typeVersion (aus bestehenden Workflows)"
if [[ "$WF_COUNT" -gt 0 ]]; then
  # Höchste real genutzte typeVersion pro Node-Typ = die, die wir verwenden.
  # In Klammern alle weiteren gefundenen Versionen (aus älteren Workflows).
  jq -r '
    [ .data[].nodes[]? | {type, v: (.typeVersion // 1)} ]
    | group_by(.type)
    | map({type: .[0].type, versions: ([.[].v] | unique | sort)})
    | .[]
    | "\(.type)\t\(.versions | last)\t\(if (.versions|length) > 1 then "(auch: \(.versions[:-1] | join(", ")))" else "" end)"
  ' <<<"$WF_BODY" | sort | awk -F'\t' '{printf "%-64s %-6s %s\n", $1, $2, $3}'
  echo
  echo "Höchste Version = die verwenden. Das ist eine Untergrenze — nur Nodes,"
  echo "die der Kunde schon nutzt. Für alles andere UI-Login oder Kunde fragen."
else
  echo "Keine Workflows vorhanden → keine Ableitung möglich."
fi

# --- 4. Volle Node-Type-Liste (nur mit UI-Login) ----------------------------
hr "Node-Types via UI-Session (/rest/node-types)"
if [[ -n "$COOKIE_JAR" ]]; then
  NT="$(curl -sS --max-time 60 -b "$COOKIE_JAR" "$BASE/rest/node-types" 2>/dev/null)"
  COUNT="$(jq -r '(.data // []) | length' <<<"$NT" 2>/dev/null || echo 0)"
  if [[ "${COUNT:-0}" -gt 0 ]]; then
    echo "$COUNT Node-Typen verfügbar:"
    jq -r '(.data // [])[] | "\(.name)\t\(.defaultVersion // (.version | if type=="array" then max else . end))"' <<<"$NT" \
      | sort | awk -F'\t' '{printf "%-64s %s\n", $1, $2}'
  else
    echo "/rest/node-types lieferte nichts Brauchbares."
    echo "Fallback: in der n8n-UI eingeloggt DevTools → Network → /rest/node-types."
  fi
else
  echo "Übersprungen (kein UI-Login). Für die VOLLE Liste: N8N_UI_USER + N8N_UI_PASSWORD setzen."
  echo "Sonst gilt die oben aus bestehenden Workflows abgeleitete Liste."
fi

hr "Fertig"
