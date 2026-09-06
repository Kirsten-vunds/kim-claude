# KIM — Claude Code für den Mittelstand

Ein Paket, das Claude Code für die tägliche Arbeit einrichtet — und mitbringt, was man braucht,
um ohne IT-Hintergrund eigene kleine Anwendungen zu bauen.

Gedacht für Menschen, die noch nie programmiert haben.

---

## Was drin ist

| | |
|---|---|
| **`/kim-start`** | Richtet den Arbeitsplatz ein: Microsoft 365 verbinden, Schutzmechanismen aktivieren, eine Notiz über Firma und Rolle anlegen. Einmal, im Gespräch, etwa 15 Minuten. |
| **Skill `software-bauen`** | Begleitet beim Bauen eigener Anwendungen — von der Idee über einen abgestimmten Plan bis zum sicheren Livegang. Springt von selbst an, wenn jemand beschreibt, was er gern hätte. |
| **Schutzmechanismen** | Fragen nach, bevor etwas Unwiderrufliches passiert. |

---

## Einrichtung

### Schritt 1 — Grundprogramme (einmal pro Rechner, etwa 10 Minuten)

Das muss von Hand passieren, weil Claude dabei noch nicht läuft.

**macOS** — Terminal öffnen (Cmd + Leertaste, „Terminal"):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install node git
brew install --cask visual-studio-code
```

**Windows** — der Reihe nach herunterladen und durchklicken, alles auf Standard lassen:

1. Node.js von <https://nodejs.org> — die **LTS**-Fassung, grüner Knopf
2. Git von <https://git-scm.com/download/win>
3. VS Code von <https://code.visualstudio.com>

Danach PowerShell schließen und neu öffnen, sonst werden die neuen Befehle nicht gefunden.

**Prüfen, ob es geklappt hat:**

```bash
node --version
git --version
```

Beides sollte eine Versionsnummer zeigen.

### Schritt 2 — Claude Code

```bash
npm install -g @anthropic-ai/claude-code
claude
```

Beim ersten Start öffnet sich ein Browserfenster für die Anmeldung.

### Schritt 3 — Dieses Paket installieren

Im laufenden Claude-Fenster:

```
/plugin marketplace add v-und-s/kim-claude
/plugin install kim-arbeitsplatz@kim
```

Claude holt sich das Paket selbst. Danach Claude einmal neu starten.

> **Kommt eine Fehlermeldung, dass die Adresse nicht erreichbar ist?** Dann ist github.com auf
> diesem Rechner gesperrt — das ist auf Firmenrechnern häufig. Es gibt einen zweiten Weg über
> ein Archiv: siehe [OHNE-GITHUB.md](OHNE-GITHUB.md).

### Schritt 4 — Einrichten

```
/kim-start
```

Claude erklärt, was es tut, und führt durch die Einrichtung. Am Ende stehen drei kleine Tests,
damit man einmal sieht, dass es wirklich funktioniert.

---

## Danach

Einfach in normaler Sprache sagen, was gebraucht wird. Ein paar Beispiele:

> Zeig mir meine letzten Mails und fasse zusammen, was dringend ist.

> Aus dieser Excel-Datei bitte eine Übersicht nach Regionen.

> Ich hätte gern ein kleines Werkzeug, in das unsere Leute auf der Messe Kontakte eintippen
> können statt auf Zettel.

Der letzte Satz startet den Bau-Skill: Er stellt ein paar Fragen, legt einen Plan vor, lässt ihn
bestätigen und baut dann — mit automatischer Sicherheitsprüfung nach jedem Schritt.

---

## Aktualisieren

```
/plugin marketplace update kim
```

Verbesserungen und Korrekturen kommen so bei allen an.

---

## Wenn etwas nicht geht

| Was passiert | Was zu tun ist |
|---|---|
| `node: command not found` | Terminal schließen und neu öffnen |
| `claude: command not found` | `npm install -g @anthropic-ai/claude-code` wiederholen |
| Nach der Installation fehlt etwas | Claude Code neu starten |
| Firmenlaptop, nichts lässt sich installieren | Mit der IT sprechen. Der Bau-Skill bringt dafür eine Vorlage mit, was genau man erfragen muss. |

Auf verwalteten Firmenrechnern sind Installationen oder der Zugriff auf github.com manchmal
gesperrt. Das lässt sich klären — meist braucht es nur die richtige, konkrete Frage an die
IT-Abteilung.

---

## Fragen

**KIM — KI im Mittelstand**
Vollmer & Scheffczyk GmbH · <kim@v-und-s.de> · <https://kim.v-und-s.de>

Lizenz: MIT
