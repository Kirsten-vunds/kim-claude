#!/usr/bin/env bash
# Speicherstaende in Alltagssprache anzeigen und zurueckkehren.
# Aufruf:  staende.sh              -> Liste
#          staende.sh --zurueck 3  -> Stand Nr. 3 wiederherstellen (sichert vorher den aktuellen)
set -u
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Hier ist kein Projekt mit Speicherstaenden."; exit 1; }

if [ "${1:-}" = "--zurueck" ]; then
  N="${2:-}"
  case "$N" in ''|*[!0-9]*) echo "Aufruf: staende.sh --zurueck <Nummer aus der Liste>"; exit 1;; esac
  SHA="$(git log --format='%H' -n 50 | sed -n "${N}p")"
  [ -z "$SHA" ] && { echo "Stand Nr. $N gibt es nicht."; exit 1; }
  # Aktuellen Stand vorher sichern, damit auch das Zurueckgehen rueckgaengig zu machen ist
  if [ -n "$(git status --porcelain)" ]; then
    git add -A >/dev/null 2>&1
    git commit -qm "Stand vor dem Zurueckgehen gesichert" >/dev/null 2>&1
  fi
  git revert --no-edit --no-commit "$SHA"..HEAD >/dev/null 2>&1 \
    && git commit -qm "Zurueck auf: $(git log -1 --format='%s' "$SHA")" >/dev/null 2>&1 \
    && { echo "Wiederhergestellt: $(git log -1 --format='%s (%cd)' --date=format:'%d.%m. %H:%M' "$SHA")"
         echo "Der vorherige Stand ist gesichert - das Zurueckgehen laesst sich rueckgaengig machen."; exit 0; }
  echo "Zurueckgehen nicht automatisch moeglich - bitte von Hand pruefen."; exit 1
fi

echo "Speicherstaende (neueste zuerst):"
git log -n 20 --format='%cd|%s' --date=format:'%d.%m. %H:%M' 2>/dev/null \
  | awk -F'|' '{printf "  %2d.  %-14s %s\n", NR, $1, $2}'
echo
echo "Zurueck auf einen Stand:  staende.sh --zurueck <Nummer>"
