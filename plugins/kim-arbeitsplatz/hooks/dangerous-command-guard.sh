#!/bin/bash
# Dangerous Command Guard — PreToolUse Hook für Bash
# Blockiert gefährliche Befehle mit Exit 2 und fragt den User.
# Wenn der User bestätigt, legt Claude eine Allow-Datei an,
# und beim zweiten Versuch wird der Befehl durchgelassen.
#
# Stdin: JSON mit dem Tool-Input (enthält "command"-Feld)

INPUT=$(cat)
# Feld heisst tool_input (offizielles PreToolUse-Format); 'input' nur als Fallback.
# Vorher wurde nur 'input' gelesen -> Hook war wirkungslos (getestet 06.09.2026).
CMD=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); ti=d.get('tool_input') or d.get('input') or {}; print(ti.get('command',''))" 2>/dev/null)

if [ -z "$CMD" ]; then
  exit 0
fi

# --- Allowlist prüfen (User hat bereits bestätigt) ---
CMD_HASH=$(echo -n "$CMD" | md5 -q 2>/dev/null || echo -n "$CMD" | md5sum | cut -d' ' -f1)
ALLOW_FILE="/tmp/.claude-allow-$CMD_HASH"

if [ -f "$ALLOW_FILE" ]; then
  rm -f "$ALLOW_FILE"
  exit 0
fi

# Alles lowercase für Pattern-Matching
CMD_LOWER=$(echo "$CMD" | tr '[:upper:]' '[:lower:]')

BLOCKED=""

# --- Dateisystem-Zerstörung ---
if echo "$CMD" | grep -qE 'rm\s+(-[a-zA-Z]*r[a-zA-Z]*f|-[a-zA-Z]*f[a-zA-Z]*r)\b'; then
  BLOCKED="rm -rf — rekursives Löschen"
fi

if echo "$CMD" | grep -qE 'rm\s+-[a-zA-Z]*r[a-zA-Z]*\s+(/\s|/\*|~\s|~/)'; then
  BLOCKED="rm -r auf Root/Home"
fi

# --- SQL-Zerstörung ---
if echo "$CMD_LOWER" | grep -qE 'drop\s+(table|database|schema)\b'; then
  BLOCKED="DROP TABLE/DATABASE — Datenbank-Löschung"
fi

if echo "$CMD_LOWER" | grep -qE 'truncate\s+table\b'; then
  BLOCKED="TRUNCATE TABLE — Tabelle leeren"
fi

if echo "$CMD_LOWER" | grep -qE 'delete\s+from\s+\S+\s*;?\s*$'; then
  BLOCKED="DELETE FROM ohne WHERE — komplette Tabelle löschen"
fi

# --- Disk/Partition-Zerstörung ---
if echo "$CMD_LOWER" | grep -qE '\bmkfs\b'; then
  BLOCKED="mkfs — Dateisystem formatieren"
fi

if echo "$CMD_LOWER" | grep -qE '\bdd\s+.*\bof=/dev/'; then
  BLOCKED="dd auf Block-Device — Disk überschreiben"
fi

# --- Git-Zerstörung ---
if echo "$CMD" | grep -qE 'git\s+push\s+.*--force\b.*\b(main|master)\b|git\s+push\s+.*\b(main|master)\b.*--force\b'; then
  BLOCKED="git push --force auf main/master"
fi

if echo "$CMD" | grep -qE 'git\s+reset\s+--hard'; then
  BLOCKED="git reset --hard — unwiderruflicher Verlust"
fi

# --- Berechtigungen ---
if echo "$CMD" | grep -qE 'chmod\s+(-R\s+)?777\s+/'; then
  BLOCKED="chmod 777 auf Root-Pfad"
fi

# --- Fork Bomb ---
if echo "$CMD" | grep -qE ':\(\)\s*\{.*\|.*&\s*\}\s*;'; then
  BLOCKED="Fork Bomb"
fi

# --- Ergebnis ---
if [ -n "$BLOCKED" ]; then
  echo "BLOCKIERT: $BLOCKED" >&2
  echo "Befehl: $CMD" >&2
  echo "" >&2
  echo "Falls gewünscht, frage den User und erstelle dann die Allow-Datei:" >&2
  echo "touch $ALLOW_FILE" >&2
  exit 2
fi

exit 0
