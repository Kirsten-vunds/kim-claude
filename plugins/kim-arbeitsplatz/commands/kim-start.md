---
description: Richtet Claude Code für die tägliche Arbeit ein — einmalig, im Gespräch. Erklärt zuerst, was installiert wurde.
---

# Arbeitsplatz einrichten

Du richtest gerade den Arbeitsplatz einer Person ein, die Claude Code zum ersten Mal benutzt und
in der Regel keinen IT-Hintergrund hat. Nimm dir Zeit für die Erklärungen und geh **einen
Schritt nach dem anderen**. Nichts ist schlimmer, als jemandem drei Aufgaben gleichzeitig zu
geben und dann nicht zu wissen, wo es hakte.

## Zuerst: Läuft das hier ein zweites Mal?

```bash
ls ~/CLAUDE.md ~/.claude/CLAUDE.md 2>/dev/null
```

Findet sich dort schon eine ausgefüllte Einrichtung, sag das und frag, ob wirklich neu
eingerichtet werden soll. Sonst überschreibst du die Arbeit von jemand anderem.

## Schritt 1 — Erklären, was gerade passiert ist

Bevor du irgendetwas tust, ein kurzer Absatz in Alltagssprache. Ungefähr so:

> Du hast gerade ein Paket installiert, das Claude für deinen Arbeitsalltag einrichtet. Was
> gleich passiert: Ich verbinde Claude mit deinem Microsoft-Konto, damit es deine Mails,
> Termine und Dateien lesen kann. Ich baue zwei Schutzmechanismen ein, die verhindern, dass
> aus Versehen etwas gelöscht wird. Und ich lege eine Notiz an, in der steht, wer du bist und
> woran du arbeitest — damit ich dich nicht jedes Mal neu fragen muss.
>
> Das dauert etwa fünfzehn Minuten. Ich frage dich unterwegs ein paar Dinge; wenn du etwas
> nicht weißt, sag einfach Bescheid, dann finden wir es zusammen heraus oder lassen es erstmal
> weg.

## Schritt 2 — Wer bist du, wo arbeitest du

Frag einzeln, nicht als Formular. Was schon aus dem Gespräch hervorgeht, überspring:

1. **In welchem Unternehmen arbeitest du, und was macht ihr?** (Branche, ungefähre Größe)
2. **Was ist deine Rolle, und was machst du an einem normalen Tag am häufigsten?**
3. **Welche Programme nutzt ihr täglich?** (ERP, CRM, Projektverwaltung — Namen reichen)
4. **Gibt es Abkürzungen oder Produktnamen, die ich kennen sollte?**
5. **Wie klingen eure E-Mails — eher förmlich oder locker?**

Schreib daraus `~/CLAUDE.md`. Halt sie kurz und in ihrer Sprache; sie wird ab jetzt bei jeder
Sitzung mitgelesen.

## Schritt 3 — Microsoft 365 verbinden

Nur wenn gewünscht. Und hier gibt es eine Entscheidung, die **nicht du und nicht KIM** trifft,
sondern die IT des Unternehmens. Leg beide Wege vor, erklär die Folgen, und lass entscheiden.

Erklär vorher, worum es überhaupt geht — der Begriff "App-Registrierung" sagt niemandem etwas:

> Damit Claude an deine Mails und Dateien darf, muss sich das Programm bei eurem Microsoft
> ausweisen. Dafür braucht es einen Ausweis, den eure IT einmal ausstellt oder freigibt. Es
> gibt zwei Wege — welcher besser passt, entscheidet eure IT, das ist ihre Zuständigkeit.

**Weg A — eure IT gibt eine bestehende Anwendung frei.** Schneller: Es muss nichts eingerichtet
werden, ein Administrator erlaubt einmal, dass diese Anwendung in eurem Microsoft-Konto benutzt
werden darf. Danach meldet sich jeder mit seinem normalen Firmenkonto an.

**Weg B — eure IT richtet eine eigene Anwendung ein.** Aufwendiger, dafür gehört der Ausweis
euch: Ihr seht im Microsoft-Verwaltungsbereich genau, was er darf, könnt Rechte enger fassen
und ihn jederzeit sperren. Manche IT-Abteilungen erlauben nur diesen Weg.

**Beides ist in Ordnung, keiner ist der bessere** — solange eine Bedingung erfüllt ist, und die
ist wichtiger als die Wahl zwischen A und B:

> **Der Zugriff muss "delegiert" sein, nicht "als Anwendung".**
>
> Delegiert heißt: Das Programm handelt in deinem Namen und kommt an genau das, woran du auch
> kommst — deine Mails, deine Dateien. Deshalb meldest du dich im Browser an.
>
> Als Anwendung heißt: Das Programm handelt ohne Person, mit eigenem Schlüssel, und kommt dann
> an **alle** Postfächer im Unternehmen. Das braucht hier niemand, und es wäre ein Risiko, das
> in keinem Verhältnis zum Nutzen steht.

Das gilt auf **beiden** Wegen. Eine unternehmenseigene Registrierung mit Anwendungsberechtigung
wäre gefährlicher als eine freigegebene mit delegiertem Zugriff — die Frage "wem gehört die
App" ist nicht die Sicherheitsfrage, die Frage nach der Berechtigungsart ist es.

Sag das der Person in einem Satz, damit sie es in der Rückfrage an die IT bringen kann. Die IT
versteht die Unterscheidung sofort.

Frag dann, ob es dazu eine Vorgabe gibt oder ob ihr die IT gemeinsam fragen sollt. Wenn die Antwort nicht sofort da ist, überspring den Schritt
und notier ihn — alles Übrige funktioniert auch ohne Microsoft-Anbindung.

### Die Anfrage an die IT

Biete an, den Text vorzubereiten, den die Person weiterschicken kann. Nicht mehr als das —
kurz, konkret, beantwortbar:

> Betreff: Freigabe für einen KI-Assistenten auf meinem Arbeitsrechner
>
> Hallo,
>
> ich nutze im Rahmen unseres KI-Programms den Assistenten Claude Code auf meinem Rechner. Er
> soll auf meine eigenen Mails, Termine und Dateien in Microsoft 365 zugreifen können — nur
> auf meine, mit meiner Anmeldung, nichts darüber hinaus.
>
> Dafür brauche ich eure Entscheidung zwischen zwei Wegen:
>
> **A)** Ihr gebt die bestehende Anwendung in unserem Tenant frei (einmalige
> Administrator-Zustimmung).
> **B)** Ihr registriert eine eigene Anwendung bei uns und gebt mir deren Kennung.
>
> In beiden Fällen brauche ich **ausschließlich delegierte Berechtigungen** (Zugriff im Namen
> des angemeldeten Nutzers), **keine Anwendungsberechtigungen** — der Assistent soll nur an
> meine eigenen Daten kommen, nicht an die anderer Kolleginnen und Kollegen.
>
> Welcher Weg passt besser zu unseren Vorgaben? Und gibt es etwas, das ich vorher wissen
> sollte — etwa Einschränkungen, welche Daten ein solcher Assistent verarbeiten darf?
>
> Danke!

Trag den gewählten Weg und die erhaltene Kennung ein, lass die Person sich im Browser anmelden
und sag vorher, dass die Berechtigungsabfrage normal ist und was Claude damit darf.

Halt die Entscheidung fest — Weg, Kennung, wer sie freigegeben hat, wann. Beim nächsten Rechner
im selben Unternehmen erspart das die ganze Runde.

## Schritt 4 — n8n verbinden

Nur wenn das Unternehmen eine n8n-Instanz hat. Du brauchst Adresse und einen API-Schlüssel.
Fehlt beides, überspring den Schritt kommentarlos — die wenigsten brauchen ihn am ersten Tag.

## Schritt 5 — Schutzmechanismen

Die Hooks dieses Plugins sind bereits aktiv, sobald es installiert ist. Erklär in einem Satz,
was sie tun: Der eine fragt nach, bevor etwas gelöscht oder überschrieben wird. Der andere
meldet sich, wenn Claude auf eine Antwort wartet.

## Schritt 6 — Drei Tests, damit man es einmal wirken sieht

Das ist der wichtigste Schritt des ganzen Setups. Vorher war alles Behauptung, jetzt sieht die
Person, dass es funktioniert. Mach sie nacheinander und lass jeweils Zeit zum Staunen:

1. **"Zeig mir meine letzten fünf E-Mails und fasse sie kurz zusammen."**
2. **Eine beliebige Excel-Datei** auf dem Schreibtisch öffnen und die wichtigsten Zahlen
   zusammenfassen lassen.
3. **Ein kurzes Besprechungsprotokoll als Word-Datei** schreiben lassen und auf dem Schreibtisch
   ablegen.

Wenn Microsoft 365 nicht verbunden ist, ersetz Test 1 und 3 durch etwas Lokales — eine Datei
zusammenfassen, einen Text schreiben.

## Schritt 7 — Abschluss

Sag drei Dinge, nicht mehr:

- **"Du kannst mir einfach in normaler Sprache sagen, was du brauchst."**
- **"Wenn etwas klemmt: Fenster schließen und `claude` neu starten. Das behebt fast alles."**
- **"Und wenn du irgendwann eine kleine Anwendung brauchst — ein Formular, eine Übersicht, ein
  Werkzeug für dein Team —, sag es einfach. Dafür ist hier auch schon alles eingerichtet."**

Der letzte Satz ist die einzige Erwähnung des Bau-Skills. Er springt von selbst an, wenn jemand
so etwas beschreibt; erklär ihn jetzt nicht.

## Wenn etwas schiefgeht

| Was passiert | Was zu tun ist |
|---|---|
| `node: command not found` | Terminal schließen und neu öffnen — nach der Node-Installation kennt das alte Fenster den Befehl noch nicht |
| `claude: command not found` | `npm install -g @anthropic-ai/claude-code` noch einmal ausführen |
| Browser öffnet sich nicht beim Anmelden | Adresse aus dem Terminal kopieren und von Hand im Browser öffnen |
| Microsoft-Anmeldung schlägt fehl | Tenant-ID prüfen; mit der IT klären, ob die Anmeldung von Fremdanwendungen erlaubt ist |
| Etwas ist nach dem Setup nicht da | Claude Code neu starten — Skills und MCP-Server werden beim Start geladen |

Wenn nichts davon hilft, notier das Problem und geh weiter. Ein halb eingerichteter Arbeitsplatz,
mit dem gearbeitet werden kann, ist besser als ein Termin, der an einer Kleinigkeit hängen
bleibt.
