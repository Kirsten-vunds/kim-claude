#!/usr/bin/env bash
# Gibt es schon eine Erstkonfiguration? Wo liegen Projekte?
# Und: Wurde der Arbeitsplatz schon anderweitig eingerichtet (Onboarding)?
set -u
CONF="$HOME/.claude/software-bauen-umgebung.md"

if [ -f "$CONF" ]; then
  echo "EINRICHTUNG=vorhanden"
  echo "DATEI=$CONF"
  B="$(grep -m1 '^\*\*Projektbasis:\*\*' "$CONF" 2>/dev/null | sed 's/^\*\*Projektbasis:\*\* *//')"
  B="$(eval echo "$B" 2>/dev/null || echo "$B")"
  echo "BASIS=${B:-unbekannt}"
  if [ -n "$B" ]; then
    [ -d "$B" ] && echo "BASIS_EXISTIERT=ja" || echo "BASIS_EXISTIERT=nein"
  fi
  if grep -q '^- \*\*Daten dürfen liegen:\*\* <' "$CONF" 2>/dev/null; then
    echo "UNVOLLSTAENDIG=ja (Platzhalter noch drin)"
  else
    echo "UNVOLLSTAENDIG=nein"
  fi
else
  echo "EINRICHTUNG=fehlt"
  echo "-> Erstkonfiguration durchfuehren, siehe SKILL.md Schritt 0"
fi

# Arbeitsplatz-Einrichtung aus einem Onboarding? Dann steht dort schon viel drin.
GEFUNDEN=""
for C in "$HOME/CLAUDE.md" "$HOME/.claude/CLAUDE.md"; do
  [ -f "$C" ] || continue
  if grep -qiE 'Unternehmen|Firma|Abteilung|Arbeitsumgebung|Branche' "$C" 2>/dev/null; then
    GEFUNDEN="$GEFUNDEN $C"
  fi
done
if [ -n "$GEFUNDEN" ]; then
  echo "ARBEITSPLATZ_EINGERICHTET=ja"
  echo "QUELLE=$GEFUNDEN"
  echo "-> Diese Datei(en) LESEN. Firma, Rolle, Systeme, IT-Kontakt NICHT erneut fragen."
else
  echo "ARBEITSPLATZ_EINGERICHTET=nein"
fi
