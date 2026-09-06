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

Nur wenn gewünscht. Du brauchst die **Tenant-ID** des Unternehmens — die weiß die IT-Abteilung.
Wenn sie nicht zur Hand ist, überspring den Schritt und notier ihn als offenen Punkt; alles
andere funktioniert trotzdem.

Trag den MCP-Server mit der Tenant-ID ein und lass die Person sich im Browser anmelden. Sie
bestätigt dabei Berechtigungen — sag vorher, dass das normal ist und was Claude damit darf.

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
