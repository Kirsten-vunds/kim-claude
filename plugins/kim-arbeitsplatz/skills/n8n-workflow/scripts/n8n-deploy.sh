#!/usr/bin/env bash
# Workflow auf eine n8n-Instanz deployen (create/update/get/list/activate) — reine Public API.
# Für Instanzen ohne MCP-Server (Kunden-Instanzen wie Guidant).
#
# Nutzung (API-URL/Key aus Env oder --url/--key):
#   n8n-deploy.sh list
#   n8n-deploy.sh get      <workflow-id>
#   n8n-deploy.sh create   <workflow.json>
#   n8n-deploy.sh update   <workflow-id> <workflow.json>
#   n8n-deploy.sh delete   <workflow-id>     # fragt nach
#   n8n-deploy.sh activate <workflow-id>
#   n8n-deploy.sh deactivate <workflow-id>
#   n8n-deploy.sh runs     <workflow-id>     # letzte Executions inkl. Fehlermeldungen
set -uo pipefail

API_URL="${N8N_API_URL:-}"
API_KEY="${N8N_API_KEY:-}"
while [[ "${1:-}" == --* ]]; do
  case "$1" in
    --url) API_URL="$2"; shift 2 ;;
    --key) API_KEY="$2"; shift 2 ;;
    *) echo "Unbekannte Option: $1" >&2; exit 2 ;;
  esac
done
API_URL="${API_URL%/}"

[[ -n "$API_URL" && -n "$API_KEY" ]] || { echo "FEHLER: \$N8N_API_URL/\$N8N_API_KEY oder --url/--key nötig." >&2; exit 2; }

api() { # method path [datafile]
  local method="$1" path="$2" file="${3:-}"
  if [[ -n "$file" ]]; then
    curl -sS -X "$method" -H "X-N8N-API-KEY: $API_KEY" \
      -H 'Content-Type: application/json' --data-binary @"$file" "$API_URL$path"
  else
    curl -sS -X "$method" -H "X-N8N-API-KEY: $API_KEY" "$API_URL$path"
  fi
}

# Payload säubern: read-only Felder, die die API mit 400 quittieren.
clean() {
  jq '{name, nodes, connections, settings: ((.settings // {}) | {executionOrder: (.executionOrder // "v1")})}' "$1"
}

CMD="${1:-}"; shift || true
case "$CMD" in
  list)
    api GET "/workflows?limit=250" | jq -r '.data[] | "\(.id)\t\(if .active then "aktiv " else "inaktiv" end)\t\(.name)"'
    ;;
  get)
    api GET "/workflows/$1" | jq .
    ;;
  create)
    TMP="$(mktemp)"; trap 'rm -f "$TMP"' EXIT
    clean "$1" > "$TMP"
    RESP="$(api POST "/workflows" "$TMP")"
    ID="$(jq -r '.id // empty' <<<"$RESP")"
    if [[ -n "$ID" ]]; then echo "Erstellt: $ID"; else echo "$RESP" | jq . ; exit 1; fi
    ;;
  update)
    TMP="$(mktemp)"; trap 'rm -f "$TMP"' EXIT
    clean "$2" > "$TMP"
    RESP="$(api PUT "/workflows/$1" "$TMP")"
    if jq -e '.id' >/dev/null 2>&1 <<<"$RESP"; then echo "Aktualisiert: $1"; else echo "$RESP" | jq .; exit 1; fi
    ;;
  delete)
    read -r -p "Workflow $1 auf $API_URL wirklich löschen? [j/N] " a
    [[ "$a" == "j" ]] || { echo "Abgebrochen."; exit 0; }
    api DELETE "/workflows/$1" | jq -r '"Gelöscht: \(.name // .message)"'
    ;;
  activate|deactivate)
    api POST "/workflows/$1/$CMD" | jq -r '"\(.name): active=\(.active)"'
    ;;
  runs)
    api GET "/executions?includeData=true&limit=5&workflowId=$1" \
      | jq -r '.data[] | "--- \(.id) \(.status) \(.startedAt)\n\(
          [ (.data.resultData.error // empty) | "FEHLER: \(.message // .description // "?")" ,
            (.data.resultData.lastNodeExecuted // empty) | "letzter Node: \(.)" ] | join("\n")
        )"'
    ;;
  *)
    sed -n '2,14p' "$0"
    exit 2
    ;;
esac
