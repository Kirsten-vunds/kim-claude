# Installation ohne GitHub

Auf vielen Firmenrechnern ist `github.com` gesperrt. Dann funktioniert der normale Weg
(`/plugin marketplace add …`) nicht — das Paket lässt sich aber trotzdem installieren.

## Weg über das Archiv

**1. Archiv entpacken.** Leg den Ordner an einen Ort, der bleiben darf — nicht in
„Downloads". Zum Beispiel `C:\Users\<name>\kim-claude` oder `~/kim-claude`.

Wichtig: **Der Ordner darf nicht gelöscht oder verschoben werden**, solange das Paket benutzt
wird. Claude greift bei jedem Start darauf zu.

**2. In Claude Code registrieren** — statt der GitHub-Adresse der Pfad zum entpackten Ordner:

```
/plugin marketplace add ~/kim-claude
/plugin install kim-arbeitsplatz@kim
```

Unter Windows mit dem vollständigen Pfad, zum Beispiel
`/plugin marketplace add C:\Users\meier\kim-claude`.

**3. Claude Code neu starten**, dann `/kim-start`.

## Was dadurch anders ist

**Aktualisierungen kommen nicht von selbst.** `/plugin marketplace update` holt nichts nach,
weil es keine Quelle im Netz gibt. Bei einer neuen Fassung: neues Archiv kommen lassen, über
den alten Ordner entpacken, Claude Code neu starten.

Das ist der eigentliche Nachteil dieses Wegs — Korrekturen erreichen den Rechner nur, wenn
sich jemand darum kümmert. Notier deshalb, wer dieses Paket per Archiv bekommen hat.

**Alles Übrige funktioniert unverändert.** Beide Skills, die Schutzmechanismen, die
Sicherheitsprüfungen — nichts davon braucht GitHub.

## Und die Projekte selbst?

Häufiges Missverständnis: **Git und GitHub sind nicht dasselbe.**

Git läuft vollständig auf dem Rechner. Speicherstände, Zurückgehen, „mach das rückgängig" —
all das funktioniert ohne Internet und ohne Konto. Genau davon kommt der Nutzen beim Bauen.

GitHub ist nur der Ort für eine **Kopie außer Haus**. Ist er gesperrt, fehlt die
Sicherheitskopie und die Möglichkeit, dass Kolleginnen mitarbeiten — sonst nichts.

Was stattdessen geht:

- ein firmeneigenes GitLab, Azure DevOps oder Gitea, falls vorhanden — die IT weiß das
- notfalls ein Netzlaufwerk als Ablage:
  ```bash
  git clone --bare mein-projekt /netzlaufwerk/projekte/mein-projekt.git
  git remote add sicherung /netzlaufwerk/projekte/mein-projekt.git
  ```
  Nicht elegant, rettet aber die Arbeit, wenn der Laptop ausfällt.

## Wenn auch das Installieren gesperrt ist

Lässt sich Node.js oder Claude Code selbst nicht installieren, hilft kein Archiv — dann führt
der Weg über die IT. Der Skill `software-bauen` bringt dafür eine Vorlage mit, was genau man
erfragen muss (`references/firmenumgebung.md`). Kurz gefasst: nicht „darf ich Software
installieren" fragen, sondern drei konkrete Punkte nennen.
