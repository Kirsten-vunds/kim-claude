#!/usr/bin/env bash
# Legt die Erstkonfiguration an und verankert sie in ~/.claude/CLAUDE.md.
# Aufruf: einrichtung-schreiben.sh "<Projektbasis-Pfad>"
set -u
BASIS="${1:-$HOME/Projekte}"
CONF="$HOME/.claude/software-bauen-umgebung.md"
VORLAGE="$(cd "$(dirname "$0")/../assets" && pwd)/EINRICHTUNG-vorlage.md"
HEUTE="$(date +%d.%m.%Y)"

[ -f "$CONF" ] && { echo "Existiert schon: $CONF (nicht ueberschrieben)"; exit 0; }
mkdir -p "$(dirname "$CONF")" "$BASIS" 2>/dev/null

# Fakten aus der Umgebung vorbelegen
OS="$(uname -s)"; case "$OS" in Darwin) OS="macOS $(sw_vers -productVersion 2>/dev/null)";; Linux) OS="Linux";; esac
if [ "$(id -u)" = "0" ] || sudo -n true 2>/dev/null; then ADMIN="ja"
elif id -Gn 2>/dev/null | grep -qE '\badmin\b|\bsudo\b|\bwheel\b'; then ADMIN="ja (Passwort noetig)"
else ADMIN="NEIN - Installationen brauchen die IT"; fi
VERWALTET="nein"
[ "$(uname -s)" = "Darwin" ] && profiles status -type enrollment 2>/dev/null | grep -qi yes && VERWALTET="ja (MDM)"
PROXY="${HTTPS_PROXY:-${https_proxy:-keiner}}"
GESPERRT=""
if command -v curl >/dev/null 2>&1; then
  for Z in "github.com|https://github.com" "npm|https://registry.npmjs.org/" "supabase|https://supabase.com" "vercel|https://vercel.com"; do
    N="${Z%%|*}"; A="${Z##*|}"
    [ "$(curl -s -o /dev/null -w '%{http_code}' -m 6 "$A" 2>/dev/null || echo 000)" = "000" ] && GESPERRT="$GESPERRT $N"
  done
fi
[ -z "$GESPERRT" ] && GESPERRT="nichts festgestellt"
# Git-Identitaet: ohne sie verweigert git spaeter den Dienst
GITID="gesetzt"
if command -v git >/dev/null 2>&1; then
  [ -z "$(git config --global user.name 2>/dev/null)" ] && GITID="FEHLT - 'git config --global user.name/.email' setzen"
fi
GH="nicht angemeldet"
command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1 && GH="$(gh api user -q .login 2>/dev/null)"

sed -e "s|{{DATUM}}|$HEUTE|g" -e "s|{{BASIS}}|$BASIS|g" -e "s|{{OS}}|$OS|g" \
    -e "s|{{ADMIN}}|$ADMIN|g" -e "s|{{VERWALTET}}|$VERWALTET|g" -e "s|{{PROXY}}|$PROXY|g" \
    -e "s|{{GESPERRT}}|$GESPERRT|g" -e "s|{{GITHUB}}|$GH|g" "$VORLAGE" > "$CONF"

# In ~/.claude/CLAUDE.md verankern, damit jede Sitzung davon weiss
GLOBAL="$HOME/.claude/CLAUDE.md"
MARKE="<!-- software-bauen -->"
if ! grep -qF "$MARKE" "$GLOBAL" 2>/dev/null; then
  { [ -f "$GLOBAL" ] && echo ""; \
    echo "$MARKE"; \
    echo "## Software bauen"; \
    echo "Umgebung, Projektbasis und Vorgaben fuer selbstgebaute Software stehen in"; \
    echo "\`~/.claude/software-bauen-umgebung.md\`. Vor jedem Bauprojekt lesen."; } >> "$GLOBAL"
  echo "Verankert in: $GLOBAL"
fi
echo "Git-Identitaet: $GITID"
echo "Angelegt: $CONF"
echo "Projektbasis: $BASIS"
