# Werkzeugkasten einrichten

Für Leute, bei denen noch nichts installiert ist. Das ist der Normalfall, nicht die Ausnahme.

## Reihenfolge

Richte nur ein, was das Projekt wirklich braucht. Ein reines Werkzeug für eine Person braucht
weder GitHub-Account noch Hosting.

| Braucht das Projekt | Dann nötig |
|---|---|
| Immer | Git, VS Code |
| Webseite oder App | Node.js |
| Code sichern, zurückgehen können | GitHub-Account |
| Von anderen erreichbar | Hosting-Account (Vercel) |
| Daten speichern | Datenbank-Account (Supabase) |
| KI eingebaut | API-Schlüssel beim Anbieter |

## Programme — die installierst du selbst

Frag einmal um Erlaubnis, dann mach es und sag Bescheid, wenn es durch ist. Nicht jeden
Zwischenschritt vorlesen.

**macOS** — erst Homebrew, dann der Rest:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git node
brew install --cask visual-studio-code
```

**Windows** — der einfachste Weg zuerst, WSL nur wenn nötig:

1. **Node.js** von https://nodejs.org, die LTS-Fassung (grüner Knopf), Installer durchklicken.
   Danach PowerShell schließen und neu öffnen, sonst wird der Befehl nicht gefunden.
2. **Git** von https://git-scm.com/download/win — bringt außerdem "Git Bash" mit, und damit
   laufen die Skripte dieses Skills.
3. **VS Code** von https://code.visualstudio.com.

WSL (ein Linux im Windows) ist für Web-Projekte technisch der bessere Unterbau, braucht aber
Administratorrechte und ist auf verwalteten Firmenrechnern oft gesperrt. Nimm es nur, wenn der
einfache Weg nicht reicht — Details in `betriebssysteme.md`.

**Warum VS Code?** Nicht zum Programmieren — dafür ist Claude da. Sondern damit die Person
ihren Projektordner sehen und `PLAN.md` und `TODO.md` öffnen kann, ohne den Umweg über den
Dateimanager. Ein Projekt, das man nicht anschauen kann, fühlt sich an wie eine Blackbox.
Dazu die Erweiterung "Claude Code" aus dem Erweiterungs-Katalog, dann läuft alles in einem
Fenster.

Auf verwalteten Firmenrechnern kann die Installation Administratorrechte brauchen. Falls sie
nicht durchgeht: Es geht auch ohne — der Editor ist Komfort, kein Muss. Dann arbeitet ihr im
Terminal weiter und öffnet Dateien über den Dateimanager.

**Git-Identität** setzen, sonst verweigert Git später den Dienst:
```bash
git config --global user.name "Vorname Nachname"
git config --global user.email "die@adresse.de"
```

## Accounts — da muss ein Mensch klicken

Du kannst keine Konten anlegen. Führ durch: **ein Dienst, ein Link, dann warten.** Nicht drei
Aufgaben auf einmal — sonst kommt jemand mit halb erledigten Schritten zurück und niemand weiß,
wo es hakt.

| Dienst | Wofür | Adresse | Worauf achten |
|---|---|---|---|
| GitHub | Code sichern, zurückgehen | github.com/signup | Firmen-Mailadresse, nicht die private — sonst gehört das Projekt später der Privatperson |
| Vercel | Webseite online stellen | vercel.com/signup | Mit dem GitHub-Konto anmelden, dann greift alles ineinander |
| Supabase | Datenbank mit Login | supabase.com/dashboard | Bei "Region" **Frankfurt (eu-central-1)** wählen |
| Anthropic | KI einbauen | console.anthropic.com | Sofort ein Ausgabenlimit setzen |

Nach jedem Account: prüfen, ob es geklappt hat, bevor es weitergeht. Bei GitHub geht das direkt:

```bash
gh auth login     # führt durch die Anmeldung im Browser
gh api user -q .login
```

## Zwei Dinge, die später Ärger sparen

**Wem gehören die Konten?** Wenn alles auf einer privaten Mailadresse läuft und die Person
das Unternehmen verlässt, ist das Projekt weg. Sprich das einmal an und schreib die Antwort
ins PLAN.md.

**Ausgabenlimit sofort setzen.** Bei jedem KI-Dienst, bevor der erste Schlüssel benutzt wird.
Ein Programmierfehler in einer Schleife kann sonst über Nacht dreistellige Beträge verbrauchen.
