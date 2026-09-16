---
name: n8n-workflow
description: >-
  Baut, aendert und veroeffentlicht n8n-Workflows auf der eigenen n8n-Instanz. Nutze diesen
  Skill IMMER, wenn eine Automatisierung zwischen Systemen gebaut werden soll — auch wenn nur
  von "Workflow", "Automatisierung", "das soll automatisch passieren", "wenn X passiert, dann Y"
  oder "n8n" die Rede ist. Raet Node-Typen und Versionen nie, sondern prueft sie an der echten
  Instanz. NICHT fuer eigene Software mit Oberflaeche und Datenbank — dafuer software-bauen.
---

# n8n-Workflows bauen

n8n ist ein Werkzeug, mit dem sich Systeme verbinden lassen, ohne zu programmieren: "Wenn eine
Mail mit Anhang kommt, leg die Datei ab und trag eine Zeile in die Tabelle ein." Wenn ein
Vorhaben so klingt — Kaestchen und Pfeile statt Bildschirmmasken —, ist n8n meist die bessere
Wahl als eigene Software.

## Bevor du anfaengst: die Instanz pruefen

**Rate niemals Node-Typen oder Versionen.** n8n aendert sie zwischen Versionen, und ein
Workflow mit einer falschen Node-Version laesst sich nicht importieren. Frag stattdessen die
laufende Instanz.

Zugang steht in der Umgebung als `N8N_API_URL` und `N8N_API_KEY`. Fehlt beides, frag danach —
den Schluessel erzeugt man in n8n unter Einstellungen → API. Die API-Adresse endet auf
`/api/v1`.

```bash
bash "$SB"/scripts/n8n-check.sh
```

Das meldet Version, erreichbare Endpunkte und vorhandene Workflows. Danach die Node-Versionen
fuer genau diese Instanz:

```bash
bash "$SB"/scripts/n8n-nodeversions.sh
```

Fuer gaengige Versionen liegen die Listen bereits unter `references/nodeversions-*.json` —
nimm die passende zur gemeldeten Version.

`"$SB"` ist der Ordner, aus dem du diese Datei gelesen hast.

## Schritt 2: Passende Nodes wählen

### Goldene Regel: Immer den spezialisierten Node nutzen

Bevor ein generischer Node (HTTP Request, Code, Convert to File) verwendet wird, prüfen ob ein dedizierter Node existiert:

| Aufgabe | Falsch | Richtig |
|---|---|---|
| Excel schreiben | Convert to File → xlsx | **Microsoft Excel 365** (append to table) |
| E-Mail senden | HTTP Request an API | **Microsoft Outlook** Node |
| KI-Extraktion | HTTP Request an Anthropic API | **AI Agent** / **Information Extractor** Node |
| PDF lesen | Code Node mit Library | **Extract from File** (operation: pdf) |
| Daten an Teams | HTTP Request an Graph API | **Microsoft Teams** Node |
| Eintrag in ein CRM | **HTTP Request** an dessen API | Nur wenn es keinen fertigen Node dafuer gibt |

### Häufig verwendete Nodes

**Microsoft 365:**
- `n8n-nodes-base.microsoftExcel` — Excel: Append, Get Rows, Create Table
- `n8n-nodes-base.microsoftOutlook` — E-Mail senden/empfangen
- `n8n-nodes-base.microsoftOneDrive` — Dateien hoch-/runterladen
- `n8n-nodes-base.microsoftTeams` — Nachrichten senden
- `n8n-nodes-base.microsoftSharePoint` — SharePoint-Listen

**CRM:**
- ~~`n8n-nodes-base.mondayCom`~~ — nicht mehr benutzen, Monday ist abgeschaltet. CRM-Schreibzugriffe laufen über HTTP Request gegen die v7-API (siehe `~/.claude/rules/crm.md`): erst `run/begin`, dann `action/<verb>` mit `X-Run-Id`, dann `run/end`.

**AI/Langchain:**
- `@n8n/n8n-nodes-langchain.agent` — AI Agent mit Prompt
- `@n8n/n8n-nodes-langchain.informationExtractor` — Strukturierte Datenextraktion
- `@n8n/n8n-nodes-langchain.chainLlm` — Basic LLM Chain
- `@n8n/n8n-nodes-langchain.outputParserStructured` — Structured Output Parser

**Core:**
- `n8n-nodes-base.formTrigger` — Formular als Trigger
- `n8n-nodes-base.form` — Mid-Workflow Formular (Human-in-the-Loop)
- `n8n-nodes-base.extractFromFile` — PDF/CSV/XLSX extrahieren
- `n8n-nodes-base.convertToFile` — JSON zu XLSX/CSV/etc. (nur wenn kein MS Excel Node passt)
- `n8n-nodes-base.code` — JavaScript Code
- `n8n-nodes-base.httpRequest` — Nur wenn kein spezialisierter Node existiert

**typeVersions NICHT aus dieser Liste nehmen — IMMER live von der Instanz abfragen (Schritt 1).** Versionen ändern sich mit n8n-Updates.

---

## Schritt 3: Workflow bauen

### Node-Konfiguration

- **typeVersion**: Immer die korrekte, auf der Instanz verfügbare Version verwenden. Niemals raten — Fehler hier sind schwer zu debuggen.
- **Credentials**: Nicht vorkonfigurieren — Kirsten fügt diese selbst in der n8n-UI hinzu.
- **LLM Sub-Nodes**: Nicht anlegen — Kirsten verbindet das Sprachmodell selbst.
- **Sticky Notes**: Erklärende Notes zu jedem Schritt hinzufügen — besonders wichtig bei Kunden-Workflows, die verständlich sein müssen.

### Binary-Felder bei Form Uploads

Wenn ein FormTrigger ein Datei-Upload-Feld hat, wird der Binary-Feldname aus dem Label generiert:
- `"Dokument (PDF)"` → Binary-Key: `Dokument__PDF_`
- `"Datei"` → Binary-Key: `Datei`
- Sonderzeichen werden durch `_` ersetzt, Leerzeichen durch `_`

Nachfolgende Nodes (z.B. Extract from File) müssen den `binaryPropertyName` auf diesen Key setzen — nicht den Standard `data`.

### Extract from File — Operationen

| Dateiformat | Operation |
|---|---|
| PDF | `"pdf"` (nicht "text"!) |
| Excel | `"xlsx"` oder `"xls"` |
| CSV | `"csv"` |
| Text | `"text"` (nur für .txt) |

### AI Agent Node

```json
{
  "parameters": {
    "promptType": "define",
    "text": "=Dein Prompt mit {{ $json.feldname }} Expressions",
    "hasOutputParser": false
  },
  "type": "@n8n/n8n-nodes-langchain.agent",
  "typeVersion": "VON INSTANZ ABFRAGEN"
}
```
- Output kommt in `$json.output`
- LLM-Verbindung: Kirsten macht das selbst (ai_languageModel connection)

### Microsoft Excel 365 — Zeilen schreiben

1. Excel-Vorlage auf OneDrive mit **Tabelle** (nicht nur Sheet!) vorbereiten
2. `resource: "table"`, `operation: "append"` verwenden
3. Spalten-Mapping konfigurieren

### Connections

```json
{
  "Quell-Node": {
    "main": [[{"node": "Ziel-Node", "type": "main", "index": 0}]]
  }
}
```

### Layout-Regeln

- Nodes horizontal in einer Reihe, Abstand ~260px
- Sticky Notes unterhalb der Nodes (y + 200)
- Übersichts-Note oben links über dem Workflow
- Position des ersten Nodes: [0, 300]

---

## Veroeffentlichen

### Via Script (Kunden-Instanzen — bevorzugt)

`scripts/n8n-deploy.sh` säubert den Payload automatisch (nur `name`, `nodes`, `connections`, `settings.executionOrder` — alles andere quittiert die API mit 400):

```bash
# Zugang der Ziel-Instanz setzen, falls nicht schon in der Umgebung:
# export N8N_API_URL=https://.../api/v1  N8N_API_KEY=...

scripts/n8n-deploy.sh list                        # was liegt schon drauf
scripts/n8n-deploy.sh create   workflow.json      # → gibt die neue ID aus
scripts/n8n-deploy.sh update   <ID> workflow.json
scripts/n8n-deploy.sh get      <ID>
scripts/n8n-deploy.sh activate <ID>
scripts/n8n-deploy.sh delete   <ID>               # fragt vorher nach
scripts/n8n-deploy.sh runs     <ID>               # Executions + Fehlermeldungen
```

> ⚠️ **zsh-Falle beim Zurücklesen:** `echo "$WF" | jq …` zerstört das JSON — zshs
> `echo` expandiert die `\n` in `jsCode`-Feldern zu echten Zeilenumbrüchen, jq
> bricht mit „control characters must be escaped" ab. Antwort immer **in eine
> Datei** schreiben und `jq … datei.json` darauf laufen lassen (oder `printf '%s'`).

### Via curl (manuell)

```bash
# Workflow erstellen (kein "tags"/"id"/"active" im Body — read-only!)
curl -s -X POST \
  -H "X-N8N-API-KEY: $API_KEY" \
  -H "Content-Type: application/json" \
  -d @workflow.json \
  "$API_URL/workflows"
```

---

## Schritt 5: Testen & Debuggen

- Nach dem Erstellen: Kirsten testet in der UI und meldet Fehler
- **Selbst debuggen ohne UI** (Kunden-Instanzen): `scripts/n8n-deploy.sh runs <ID>` liest Executions mit `includeData=true` → voller Node-Output und komplette Fehlermeldung.
- **Manuelles Execute gibt es in der Public API nicht** (405). Test-Trick: Schedule-Trigger auf 1-Minuten-Intervall, aktivieren, ~85 s warten, Execution lesen, danach deaktivieren.
- Häufige Fehler:
  - Binary-Feldname stimmt nicht → FormTrigger Output prüfen
  - Falsche Operation (text statt pdf)
  - Node-Version existiert nicht auf der Instanz
  - Fehlende Credentials → Kirsten fügt die selbst hinzu

---

## Checkliste vor dem Deployen

- [ ] Gefragt welche Instanz?
- [ ] n8n-Version der Ziel-Instanz geprüft (`scripts/n8n-check.sh` bei Kunden-Instanzen)?
- [ ] Alle Node-Typen und typeVersions live von Instanz abgefragt?
- [ ] Bei US-Cloud-Restriktion des Kunden: kein Node, der echte Daten an US-Dienste schickt?
- [ ] Spezialisierte Nodes statt generische verwendet?
- [ ] Binary-Feldnamen korrekt gemappt?
- [ ] Richtige Operationen (pdf, nicht text)?
- [ ] Keine Credentials oder LLM Sub-Nodes eingebaut?
- [ ] Sticky Notes mit Erklärungen?
- [ ] Tags-Feld nicht im API-Payload?
- [ ] Richtige Deployment-Methode (MCP vs. curl) für die Instanz?


## Wenn es klemmt

| Was passiert | Woran es meist liegt |
|---|---|
| Import scheitert mit "unknown node type" | Node-Version passt nicht zur Instanz — Versionen neu abfragen |
| API antwortet 401 | Schluessel abgelaufen oder falsch; in n8n neu erzeugen |
| API antwortet 404 auf `/api/v1/...` | Public API in den Einstellungen nicht aktiviert |
| Workflow laeuft, tut aber nichts | Ist er aktiviert? Trigger richtig konfiguriert? |
| Manuelles Ausfuehren gibt 405 | Manche Instanzen erlauben das nicht — ueber den Trigger testen |

## Was du der Person erklaerst

Sie muss n8n nicht verstehen. Zeig ihr, **was der Workflow tut**, nicht wie er aufgebaut ist:
"Ab jetzt landet jede Mail mit einer Rechnung im Anhang automatisch im Ordner und in eurer
Liste — ihr braucht nichts mehr abzutippen."

Und sag, **woran sie merkt, dass etwas nicht funktioniert**, und wen sie dann anspricht. Eine
Automatisierung, die still ausfaellt, faellt lange nicht auf.
