#!/usr/bin/env bash
# Node-Versionen einer n8n-Version auslesen — OHNE Zugriff auf die Zielinstanz.
#
# Trick ("Version-Twin"): dasselbe Docker-Image wie beim Kunden lokal starten und
# die Node-Klassen introspizieren. Gleiche n8n-Version = gleiche Node-Versionen.
# Damit brauchen wir bei Kunden-Instanzen weder SSH noch UI-Login — nur die
# Versionsnummer (n8n-UI: Hilfe → About).
#
# Nutzung:
#   n8n-nodeversions.sh 2.34.5                      # Docker lokal
#   N8N_DOCKER_HOST=<host> n8n-nodeversions.sh 2.34.5  # Docker per SSH (falls lokal keiner laeuft)
#
# Ausgabe: JSON-Array [{type, defaultVersion, versions[]}] nach stdout,
# Fortschritt nach stderr. Ergebnis in references/ ablegen und im Skill zitieren.
set -uo pipefail

VERSION="${1:-}"
[[ -n "$VERSION" ]] || { echo "Nutzung: $0 <n8n-version>   (z.B. 2.34.5)" >&2; exit 2; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DUMPER="$SCRIPT_DIR/dump-node-versions.js"
[[ -f "$DUMPER" ]] || { echo "FEHLER: $DUMPER fehlt." >&2; exit 1; }

IMAGE="n8nio/n8n:$VERSION"
# Hinweis: Der Weg ueber SSH funktioniert nur mit Shell-Zugang zum Server.
# Ohne Shell-Zugang stattdessen n8n-check.sh benutzen (nur API-Schluessel noetig).
REMOTE="${N8N_DOCKER_HOST:-}"

if [[ -n "$REMOTE" ]]; then
  echo "Docker auf $REMOTE, Image $IMAGE" >&2
  scp -q "$DUMPER" "$REMOTE:/tmp/n8n-dump-node-versions.js" || exit 1
  ssh "$REMOTE" "docker pull -q $IMAGE >/dev/null && \
    docker run --rm -v /tmp/n8n-dump-node-versions.js:/tmp/d.js:ro \
      --entrypoint node $IMAGE /tmp/d.js"
else
  command -v docker >/dev/null || { echo "FEHLER: kein docker. Setze N8N_DOCKER_HOST=<host> fuer Docker per SSH." >&2; exit 1; }
  docker info >/dev/null 2>&1 || { echo "FEHLER: Docker-Daemon läuft nicht. Setze N8N_DOCKER_HOST=<host> fuer Docker per SSH." >&2; exit 1; }
  echo "Docker lokal, Image $IMAGE" >&2
  docker pull -q "$IMAGE" >/dev/null || exit 1
  docker run --rm -v "$DUMPER:/tmp/d.js:ro" --entrypoint node "$IMAGE" /tmp/d.js
fi
