# {{NAME}} — Plan

*Angelegt am {{DATUM}}. Dieses Dokument ist die Wahrheit über das Projekt — es wird beim
Weiterbauen mitgepflegt, nicht am Ende geschrieben.*

## Worum es geht

<Zwei, drei Sätze in Alltagssprache. Was das Ding tut und für wen. So formuliert, dass jemand
es versteht, der nie dabei war.>

## Ambitionsstufe

**<POC | MVP | Produktiv>** — <in einem Satz, was das hier konkret heißt>

## Wer benutzt es

| Wer | Was darf die Person |
|---|---|
| | |

## Der wichtigste Ablauf

<Der eine Weg durch die Anwendung, der am häufigsten passiert. Schritt für Schritt.
Das ist die erste Version — alles andere kommt danach.>

## Ausdrücklich NICHT in dieser Version

- <Was bewusst draußen bleibt. Diese Liste schützt vor dem Ausufern und ist genauso
  wichtig wie die Liste dessen, was drin ist.>

## Welche Daten drinliegen

| Was | Wie heikel | Was daraus folgt |
|---|---|---|
| | | |

## Wie es gebaut ist

| Baustein | Wofür | Warum diese Wahl |
|---|---|---|
| | | |

## Schnittstellen — was hängt woran

*Alles, was von außen kommt oder nach außen geht. Jede Zeile ist eine Stelle, an der etwas
ausfallen kann.*

| Gegenstelle | Wozu | Was passiert bei Ausfall |
|---|---|---|
| | | |

## Sicherheitsvorgaben für dieses Projekt

*Was hier gilt, abgeleitet aus den Daten und dem Nutzerkreis. Bei jeder Änderung mitprüfen.*

- **Zugang:** <kein Login / Login für Team / Login mit Rollen>
- **Zugriffsprüfung:** <wo genau sie sitzt>
- **Zugangsdaten:** in `.env`, nicht im Code, nicht im Browser-Teil
- **Verschlüsselung:** <Verbindung, ruhende Daten>
- **Löschen und Export:** <vorhanden / nicht nötig, weil …>
- **Grenzen für KI-Aufrufe:** <Ausgabenlimit, welche Rechte der Agent hat>
- **Letzte Prüfung:** <Datum, Ergebnis>

## Bewusst weggelassen — nachzuholen, bevor es produktiv geht

*Beim POC/MVP ist es richtig, Dinge wegzulassen. Falsch wäre nur, sie zu vergessen.*

- [ ] <z. B. Backups einrichten und eine Wiederherstellung testen>
- [ ] <z. B. Fehlerbenachrichtigung, damit jemand merkt, wenn es steht>
- [ ] <z. B. automatische Tests für den wichtigsten Ablauf>

## Entscheidungen und warum

*Damit in vier Monaten niemand rätselt, warum etwas so ist. Neue Einträge unten anhängen,
alte nicht löschen.*

| Datum | Entscheidung | Grund | Was dagegen sprach |
|---|---|---|---|
| | | | |

## Zugänge und Betrieb

- **Läuft auf:** <Anbieter, Adresse>
- **Daten liegen bei:** <Anbieter, Land>
- **Code liegt auf:** <GitHub-Adresse>
- **Wem gehören die Accounts:** <Person oder Firma — wichtig, wenn jemand geht>
- **Wer merkt es, wenn es steht:** <Name>
- **Wie man es startet:** <der eine Befehl bzw. die Adresse>
- **Wie eine neue Version live geht:** <Weg in einem Satz>
- **Wie man ein Backup zurückspielt:** <Weg in einem Satz — und wann das zuletzt getestet wurde>

## Mit jemandem klären, der sich auskennt

*Keine Aufgaben, nur Notizen — abarbeiten, wenn es ernst wird.*

- <z. B. Datenschutzbeauftragte fragen, ob die Mitarbeiterdaten so gespeichert werden dürfen>
