# Betriebssysteme

Auf welchem Rechner die Person sitzt, ändert mehr, als man denkt — besonders unter Windows,
das im Mittelstand der Normalfall ist.

## Windows — der wichtigste Fall

**Es gibt dort standardmäßig keine Bash.** Die Skripte dieses Skills laufen nicht in der
Eingabeaufforderung oder in PowerShell. Zwei Wege:

1. **Git Bash** — kommt mit "Git für Windows" mit, ist die kleinste Lösung. Danach laufen die
   Skripte.
2. **WSL** (Ubuntu im Windows) — der bessere Weg für alles, was mit Node und Web zu tun hat.
   `wsl --install` in PowerShell als Administrator, danach Neustart. Auf verwalteten
   Firmenrechnern oft gesperrt.

**Wenn beides fehlt und nichts installiert werden darf:** Führ die Prüfungen von Hand aus,
statt aufzugeben. Die Skripte sind nur Bequemlichkeit — inhaltlich prüfst du dieselben Dinge:
liegt ein Schlüssel im Code, ist `.env` in `.gitignore`, steht `.env` in der
Versionsverwaltung, kommt ohne Login etwas aus der Anwendung heraus. Sag der Person offen,
dass du langsamer bist, aber nicht ungenauer.

**Vier Windows-Fallen, die Laien nie zuordnen können:**

- **Zeilenenden.** Windows schreibt `\r\n`, Shell-Skripte vertragen das nicht — die
  Fehlermeldung lautet dann sinngemäß "Befehl nicht gefunden" mit einem unsichtbaren Zeichen.
  Einmal `git config --global core.autocrlf input` setzen.
- **Groß- und Kleinschreibung.** Windows unterscheidet sie in Dateinamen nicht, der Server
  später schon. `Header.tsx` und `header.tsx` sind lokal dasselbe und online nicht — der
  Klassiker "läuft bei mir, aber nicht online".
- **WSL und Windows-Dateien.** Projekte gehören ins Linux-Dateisystem (`~/projekte`), nicht
  nach `/mnt/c/...`. Über die Grenze hinweg ist alles zehnmal langsamer.
- **Virenscanner.** Der prüft jede der zehntausend Dateien in `node_modules`. Wenn
  Installationen ewig dauern, ist meist das die Ursache — eine Ausnahme für den Projektordner
  hilft, muss aber oft die IT eintragen.

**Wo Projekte liegen:** nicht in einem Ordner, der mit OneDrive oder SharePoint synchronisiert
wird. Die Synchronisierung und `node_modules` vertragen sich nicht. Frag das bei der
Erstkonfiguration ab, wenn der vorgeschlagene Pfad danach aussieht.

## macOS

Der bequemste Fall. Bash und Python sind da, Git kommt über `xcode-select --install`, alles
Weitere über Homebrew.

Zwei Dinge: Das Dateisystem unterscheidet standardmäßig **keine** Groß- und Kleinschreibung —
dieselbe Falle wie unter Windows. Und auf verwalteten Firmen-Macs verhindert MDM oft die
Homebrew-Installation; der Umgebungs-Scan zeigt das an.

## Linux

Unproblematisch. Paketmanager je nach Distribution (`apt`, `dnf`, `pacman`), Groß- und
Kleinschreibung wird unterschieden — hier fällt der Fehler von oben sofort auf statt erst
beim Livegang.

## Was das für den Bau heißt

Bau nichts, was vom Betriebssystem der bauenden Person abhängt. Konkret: keine festen Pfade
mit `C:\` oder `/Users/`, Pfade immer zusammensetzen lassen statt Trennzeichen selbst zu
schreiben, und Zeitzonen ausdrücklich behandeln statt auf die Einstellung des Rechners zu
vertrauen. Die Anwendung läuft am Ende auf einem Linux-Server, auch wenn sie auf einem
Windows-Laptop entstanden ist.
