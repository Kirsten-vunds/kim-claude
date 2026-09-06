#!/bin/bash
# Claude Code Desktop Notification Hook
# Sendet macOS-Benachrichtigungen bei Notification und Stop Events.
# Umgebungsvariablen von Claude Code:
#   CLAUDE_EVENT_TYPE — "Notification" oder "Stop"
#   CLAUDE_NOTIFICATION — Nachricht bei Notification-Events
#   CLAUDE_STOP_HOOK_ACTIVE_TASK_SUMMARY — Aufgabenzusammenfassung bei Stop-Events
#   CLAUDE_TERMINAL_SESSION_ID — Terminal-Identifikation

# Terminal-Info: TTY oder Session-ID
TERMINAL=""
if [ -n "$CLAUDE_TERMINAL_SESSION_ID" ]; then
  TERMINAL="$CLAUDE_TERMINAL_SESSION_ID"
elif [ -n "$TTY" ]; then
  TERMINAL="$TTY"
else
  TERMINAL="$$"
fi
# Kürzen auf die letzten Zeichen
TERMINAL="${TERMINAL##*/}"

if [ "$CLAUDE_EVENT_TYPE" = "Notification" ]; then
  MSG="${CLAUDE_NOTIFICATION:-Claude braucht Input}"
  osascript -e "display notification \"${MSG//\"/\\\"}\" with title \"Claude wartet\" subtitle \"Terminal: $TERMINAL\""

elif [ "$CLAUDE_EVENT_TYPE" = "Stop" ]; then
  TASK="${CLAUDE_STOP_HOOK_ACTIVE_TASK_SUMMARY:-Aufgabe abgeschlossen}"
  osascript -e "display notification \"${TASK//\"/\\\"}\" with title \"Claude fertig\" subtitle \"Terminal: $TERMINAL\""
fi
