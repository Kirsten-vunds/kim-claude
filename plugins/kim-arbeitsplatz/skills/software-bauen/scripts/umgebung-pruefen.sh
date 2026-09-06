#!/usr/bin/env bash
# Was ist an Werkzeug da, was fehlt? Reine Bestandsaufnahme, ändert nichts.
set -u

have() { command -v "$1" >/dev/null 2>&1; }
zeile() { printf '%-14s %-6s %s\n' "$1" "$2" "${3:-}"; }

echo "== SYSTEM =="
case "$(uname -s)" in
  Darwin) echo "OS             macOS $(sw_vers -productVersion 2>/dev/null)"
          have brew && echo "Paketmanager   homebrew" || echo "Paketmanager   FEHLT (homebrew)" ;;
  Linux)  echo "OS             Linux $( (. /etc/os-release 2>/dev/null && echo "$PRETTY_NAME") || true)"
          for pm in apt dnf pacman; do have $pm && echo "Paketmanager   $pm"; done ;;
  *)      echo "OS             $(uname -s) (Windows: bitte WSL oder Git Bash)" ;;
esac
echo

echo "== WERKZEUG =="
FEHLT=""
for t in git node npm python3 docker gh code; do
  if have "$t"; then
    case "$t" in
      git)     zeile git     DA "$(git --version 2>/dev/null | awk '{print $3}')" ;;
      node)    zeile node    DA "$(node -v 2>/dev/null)" ;;
      npm)     zeile npm     DA "$(npm -v 2>/dev/null)" ;;
      python3) zeile python3 DA "$(python3 -V 2>/dev/null | awk '{print $2}')" ;;
      docker)  zeile docker  DA "$(docker --version 2>/dev/null | awk '{print $3}' | tr -d ,)" ;;
      gh)      zeile gh      DA "$(gh --version 2>/dev/null | head -1 | awk '{print $3}')" ;;
      code)    zeile editor  DA "VS Code" ;;
    esac
  else
    zeile "$t" FEHLT
    FEHLT="$FEHLT $t"
  fi
done
echo

echo "== ZUGAENGE =="
if have gh; then
  if gh auth status >/dev/null 2>&1; then
    echo "GitHub         angemeldet als $(gh api user -q .login 2>/dev/null || echo '?')"
  else
    echo "GitHub         NICHT angemeldet  -> 'gh auth login'"
  fi
else
  echo "GitHub         unbekannt (gh fehlt)"
fi
if have git; then
  N="$(git config --global user.name 2>/dev/null || true)"
  [ -n "$N" ] && echo "Git-Identitaet $N <$(git config --global user.email 2>/dev/null)>" \
              || echo "Git-Identitaet NICHT gesetzt -> git config --global user.name/.email"
fi
echo

echo "== FIRMENRECHNER? =="
# Adminrechte
if [ "$(id -u)" = "0" ]; then
  echo "Rechte         root"
elif sudo -n true 2>/dev/null; then
  echo "Rechte         Admin (sudo ohne Passwort)"
elif id -Gn 2>/dev/null | grep -qE '\badmin\b|\bsudo\b|\bwheel\b'; then
  echo "Rechte         Admin (Passwort noetig)"
else
  echo "Rechte         KEIN Admin -> Installationen brauchen die IT"
fi

# Verwaltet / MDM
if [ "$(uname -s)" = "Darwin" ]; then
  if profiles status -type enrollment 2>/dev/null | grep -qi 'Yes'; then
    echo "Geraet         von einer Firma verwaltet (MDM)"
  fi
fi
[ -n "${USERDNSDOMAIN:-}" ] && echo "Domaene        ${USERDNSDOMAIN}"

# Proxy
PROXY="${HTTPS_PROXY:-${https_proxy:-${HTTP_PROXY:-${http_proxy:-}}}}"
[ -n "$PROXY" ] && echo "Proxy          $PROXY" || echo "Proxy          keiner gesetzt"

# Schreibrechte im Benutzerordner (Fallback-Installationen)
if touch "$HOME/.sb-schreibtest" 2>/dev/null; then
  rm -f "$HOME/.sb-schreibtest"; echo "Benutzerordner beschreibbar"
else
  echo "Benutzerordner NICHT beschreibbar -> stark eingeschraenkt"
fi
echo

echo "== ERREICHBARKEIT =="
if command -v curl >/dev/null 2>&1; then
  for Z in "github.com|https://github.com" \
           "npm|https://registry.npmjs.org/" \
           "python|https://pypi.org/simple/" \
           "supabase|https://supabase.com" \
           "vercel|https://vercel.com" \
           "anthropic|https://api.anthropic.com"; do
    NAME="${Z%%|*}"; ADR="${Z##*|}"
    C="$(curl -s -o /dev/null -w '%{http_code}' -m 6 "$ADR" 2>/dev/null || echo 000)"
    case "$C" in
      000) printf '%-14s %s\n' "$NAME" "NICHT ERREICHBAR (gesperrt, Proxy oder offline)" ;;
      4*)  printf '%-14s %s\n' "$NAME" "erreichbar (HTTP $C)" ;;
      *)   printf '%-14s %s\n' "$NAME" "erreichbar" ;;
    esac
  done
else
  echo "curl fehlt - Erreichbarkeit nicht pruefbar"
fi
echo

echo "== HIER =="
echo "Ordner         $PWD"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Git-Projekt    ja (Branch: $(git branch --show-current 2>/dev/null || echo '-'))"
  git remote -v 2>/dev/null | head -1 | sed 's/^/Remote         /'
else
  echo "Git-Projekt    nein"
fi
for f in package.json requirements.txt pyproject.toml docker-compose.yml PLAN.md; do
  [ -f "$f" ] && echo "Gefunden       $f"
done
echo

echo "== FAZIT =="
if [ -n "$FEHLT" ]; then
  echo "FEHLT:$FEHLT"
  echo "-> references/werkzeugkasten.md lesen und nur das einrichten, was das Projekt braucht."
else
  echo "Alles Noetige ist da."
fi
echo "-> Bei fehlenden Adminrechten, gesetztem Proxy oder nicht erreichbaren Diensten:"
echo "   references/firmenumgebung.md lesen, BEVOR etwas installiert wird."
