#!/usr/bin/env bash
# Legt einen Projektordner mit Doku-Geruest an. Ueberschreibt nie etwas Vorhandenes.
set -u
OHNE_GIT=0
ARGS=()
for a in "$@"; do
  if [ "$a" = "--ohne-git" ]; then OHNE_GIT=1; else ARGS+=("$a"); fi
done
set -- ${ARGS[@]+"${ARGS[@]}"}
NAME="${1:-}"
CONF="$HOME/.claude/software-bauen-umgebung.md"
if [ -n "${2:-}" ]; then
  BASIS="$2"
elif [ -f "$CONF" ]; then
  BASIS="$(grep -m1 '^\*\*Projektbasis:\*\*' "$CONF" | sed 's/^\*\*Projektbasis:\*\* *//')"
  BASIS="$(eval echo "${BASIS:-$HOME/Projekte}" 2>/dev/null || echo "$HOME/Projekte")"
else
  echo "FEHLER: Keine Erstkonfiguration gefunden ($CONF)."
  echo "Zuerst Schritt 0 aus dem Skill durchfuehren (einrichtung-schreiben.sh)."
  exit 2
fi
[ -z "$NAME" ] && { echo "Aufruf: projekt-anlegen.sh <projektname> [basisordner]"; exit 1; }

SLUG="$(printf '%s' "$NAME" | tr '[:upper:]' '[:lower:]' \
  | sed 's/ä/ae/g;s/ö/oe/g;s/ü/ue/g;s/ß/ss/g' \
  | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"
ZIEL="$BASIS/$SLUG"
VORLAGEN="$(cd "$(dirname "$0")/../assets" && pwd)"
SKILLPFAD="$(cd "$(dirname "$0")/.." && pwd)"
HEUTE="$(date +%d.%m.%Y)"

[ -d "$ZIEL" ] && { echo "Existiert schon: $ZIEL"; echo "PFAD=$ZIEL"; exit 0; }
mkdir -p "$ZIEL" || exit 1

for v in PLAN TODO VERLAUF CLAUDE FUER-DIE-IT; do
  if [ -f "$VORLAGEN/$v-vorlage.md" ]; then
    sed -e "s/{{NAME}}/$NAME/g" -e "s/{{DATUM}}/$HEUTE/g" -e "s|{{SKILLPFAD}}|$SKILLPFAD|g" "$VORLAGEN/$v-vorlage.md" > "$ZIEL/$v.md"
  fi
done

cat > "$ZIEL/.gitignore" <<'GI'
# Echte Daten zum Testen - bleiben lokal
daten/
*.csv
*.xlsx
*.xls
!daten/LIESMICH.md

# Zugangsdaten - darf NIE mit hochgeladen werden
.env
.env.*
!.env.beispiel
*.pem
*.key
secrets/

# Krempel
node_modules/
__pycache__/
.venv/
venv/
dist/
build/
.DS_Store
*.log
.vercel
GI

mkdir -p "$ZIEL/daten"
cat > "$ZIEL/daten/LIESMICH.md" <<'DAT'
# daten/

Hier hinein gehoeren echte Daten zum Testen — Exporte, Tabellen, Beispieldokumente.

Dieser Ordner ist von der Versionsverwaltung ausgeschlossen: Was hier liegt, wird nie
hochgeladen und nie weitergegeben. Deshalb ist es der einzige Ort im Projekt, an dem
echte Namen, Adressen oder Kundendaten liegen duerfen.

Wenn der Test vorbei ist: aufraeumen.
DAT

cat > "$ZIEL/.env.beispiel" <<'ENV'
# Vorlage. Echte Werte kommen in .env - die wird NICHT hochgeladen.
# DATENBANK_URL=
# API_SCHLUESSEL=
ENV

if [ $OHNE_GIT -eq 0 ] && command -v git >/dev/null 2>&1; then
  git -C "$ZIEL" init -q 2>/dev/null && git -C "$ZIEL" add -A 2>/dev/null \
    && git -C "$ZIEL" commit -qm "Projekt angelegt" 2>/dev/null && echo "Git: initialisiert"
fi

[ $OHNE_GIT -eq 1 ] && echo "Ohne Versionsverwaltung angelegt (--ohne-git)"
echo "Angelegt: $ZIEL"
ls -1 "$ZIEL"
echo "PFAD=$ZIEL"
