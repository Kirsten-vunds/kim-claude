# Entscheidungen vorlegen

Der Grundsatz: **Nichts ins Blaue fragen, nichts Folgenreiches still entscheiden.** Der Weg
dazwischen ist immer derselbe — zwei, drei echte Möglichkeiten, in Alltagssprache erklärt, mit
den Folgen, die sie spürt, und deiner Empfehlung dahinter.

## Wie tief legst du vor?

Nicht danach, wie technisch etwas klingt, sondern danach, was es für sie bedeutet:

**Zur Wahl stellen**, wenn es Geld kostet, eine Abhängigkeit schafft, andere Menschen
hineinzieht oder später nur mit Neubau zu ändern ist.

**Ansagen mit Begründung**, wenn es spürbare Folgen hat, aber umkehrbar ist. Ein Satz, Veto
jederzeit möglich.

**Still entscheiden**, wenn sie davon nichts merkt — Aufbau des Codes, Benennungen, Hilfsmittel.

Und immer: Wenn sie nachfragt, erklärst du. Manche wollen es genau wissen, andere winken ab —
das merkst du nach zwei Antworten und richtest dich danach.

## Wie du vorlegst

Zwei bis drei Möglichkeiten, nie mehr. Jede in ein, zwei Sätzen. **Erklär die Folgen, nicht die
Technik** — was es kostet, wer dafür gebraucht wird, was passiert, wenn es mehr wird, was später
schwer zu ändern ist. Dann deine Empfehlung mit Begründung, dann die Frage.

Keine Vor- und Nachteilslisten mit Sternchen. Keine Tabelle mit acht Zeilen. Wenn eine
Möglichkeit an ihren Vorgaben scheitert, nenn sie trotzdem kurz und sag, warum sie ausfällt —
das erspart die Rückfrage "und warum nicht einfach …".

## Auch die technischen Fragen sind Fragen

Wenn eine Entscheidung Folgen hat, die sie spürt, dann leg sie vor — auch wenn sie technisch
klingt. So wird "welche Datenbank" zu etwas Beantwortbarem:

> Für die Daten gibt es zwei sinnvolle Wege. **Eine Datei auf dem Rechner** — am einfachsten,
> nichts einzurichten, aber sobald zwei Leute gleichzeitig etwas eintragen, geht das schief.
> Oder eine **richtige Datenbank** — etwas mehr Einrichtung, dafür können beliebig viele
> gleichzeitig arbeiten und es lässt sich sichern. Bei euch tippen mehrere gleichzeitig auf der
> Messe, deshalb würde ich die Datenbank nehmen. Einverstanden?

Weitere Beispiele in derselben Machart:

**Fertige Bausteine oder selbst gebaut** (Login, Zahlungen, Mailversand): *"Den Login baue ich
nicht selbst, sondern nehme einen fertigen Dienst — nicht aus Bequemlichkeit, sondern weil
selbstgebaute Anmeldungen die häufigste Sicherheitslücke sind. Kostet bei eurer Größe nichts.
Wenn ihr schon eine Firmenanmeldung habt, hänge ich das lieber daran, dann braucht niemand ein
zweites Passwort — gibt es so etwas bei euch?"*

**Welcher KI-Anbieter**, wenn KI beteiligt ist: *"Die Antworten kommen von einem Sprachmodell.
Da hängt dran, wohin eure Texte laufen — es gibt Anbieter mit Verarbeitung in Europa und
solche in den USA. Die europäischen sind für Kundendaten die ruhigere Wahl, die
amerikanischen zum Teil etwas besser. Bei Anfragen mit Kundennamen würde ich europäisch
bleiben."*

**Wie es bedient wird:** *"Als Seite im Browser, die auch auf dem Handy funktioniert — Link
oder QR-Code, nichts zu installieren. Eine echte App aus dem Store wäre Entwicklerkonten und
ein Freigabeverfahren bei Apple, und jede Änderung müsste da wieder durch. Ich würde bei der
Seite bleiben."*

## Die vier großen Weichen

Diese betreffen fast jedes Projekt und gehören immer zur Wahl gestellt.

## Fork 1 — Wo die Daten liegen

Die folgenreichste Entscheidung. Alles andere hängt daran.

**a) Bei einem Cloud-Anbieter in Europa.** Läuft sofort, kostet für kleine Projekte nichts bis
wenig, niemand muss einen Server pflegen. Die Daten liegen bei einer fremden Firma — mit
Vertrag und in der EU, aber eben nicht im Haus.

**b) Auf einem Server der Firma.** Die Daten verlassen das Haus nicht. Dafür braucht es jemanden
aus der IT, der den Server bereitstellt und pflegt, und alles dauert länger — Freigaben,
Wartungsfenster, Zuständigkeiten.

**c) Nur auf deinem Rechner.** Sofort startklar, nichts geht nach außen, kostet nichts. Dafür
kann niemand sonst es benutzen, und wenn der Laptop kaputtgeht, ist es weg.

*Meist richtig:* (a) für interne Werkzeuge ohne besonders heikle Daten, (c) für ein Werkzeug für
eine Person, (b) wenn es Vorgaben gibt oder die Daten wirklich heikel sind.

*Später änderbar?* Von (c) auf (a) mit überschaubarem Aufwand. Von (a) auf (b) ist ein Umzug.

## Fork 2 — Wer drankommt und von wo

**a) Nur auf deinem Rechner.** Kein Login nötig, nichts erreichbar, nichts abzusichern.

**b) Im Firmennetz.** Kolleginnen kommen ran, aus dem Internet niemand. Braucht Login, aber die
Angriffsfläche ist klein. Wer von zu Hause arbeitet, braucht VPN.

**c) Aus dem Internet, mit Login.** Alle kommen von überall ran, auch vom Handy. Dafür ist es
im Netz sichtbar und muss ordentlich abgesichert sein — richtiger Login, Rechte pro Datensatz,
Bremse gegen Angriffe, Überwachung.

*Sag ehrlich, was (c) bedeutet:* nicht mehr Arbeit beim Bauen, aber dauerhaft mehr
Verantwortung.

*Später änderbar?* Von (b) auf (c) geht, wenn von Anfang an serverseitig geprüft wird. Wurde
das versäumt, ist es ein Umbau.

## Fork 3 — Anbindung an bestehende Systeme

**a) Gar nicht.** Daten werden als Tabelle exportiert und von Hand übernommen. Klingt
altmodisch, funktioniert immer und macht das Projekt unabhängig.

**b) Einseitig lesen.** Das Werkzeug holt sich Daten aus dem anderen System, schreibt aber
nichts zurück. Deutlich einfacher und ungefährlicher als beidseitig.

**c) Beidseitig verbunden.** Beide Systeme schreiben ineinander. Am bequemsten, am
aufwendigsten, und bei Störungen am schwersten zu durchschauen.

*Die Frage vorweg, sonst ist alles Theorie:* Hat das andere System überhaupt eine
Schnittstelle, und darf sie benutzt werden? Das weiß meist nur die IT oder der Hersteller —
und die Antwort ist oft "nein" oder "kostet extra".

*Empfehlung:* Fang bei (a) an, auch wenn (c) das Ziel ist. Dann steht das Werkzeug, bevor die
Verhandlung mit dem Hersteller beginnt.

## Fork 4 — Wer es später betreibt

**a) Du selbst, mit Claude.** Änderungen gehen schnell, du bist unabhängig. Aber es hängt an
dir — bei Urlaub, Krankheit oder Jobwechsel steht es still.

**b) Die IT übernimmt.** Ordentlich betreut, in die Firmenprozesse eingebunden. Dafür bist du
nicht mehr Herr über Änderungen und musst Wünsche anmelden.

**c) Niemand — das ist ein Experiment.** Völlig in Ordnung, wenn es ausgesprochen wird und
irgendwann abgeschaltet oder übergeben wird.

*Diese Frage stellt sonst niemand*, und sie entscheidet, ob das Werkzeug in zwei Jahren noch
läuft. Wenn die Antwort (a) ist, gehört mindestens eine Anleitung dazu, mit der jemand anderes
weitermachen könnte.

---

## Die IT einbeziehen — früh und konkret

Zwei Fragen an die Person, sobald ein Fork Vorgaben berührt:

> "Gibt es bei euch Vorgaben, wo Daten liegen dürfen? Und gibt es jemanden aus der IT, den wir
> das fragen sollten, bevor wir uns festlegen?"

Wenn ja, hol die IT **vor** dem Bauen ins Boot, nicht danach. Ein Werkzeug, das an der IT
vorbei entsteht, wird abgeschaltet, sobald es wichtig wird — und dann ist die Arbeit weg.

Dafür erzeugst du das Dokument `FUER-DIE-IT.md` im Projektordner. Es ist das einzige Dokument
des Projekts, das sich an Fachleute richtet: was wo läuft, welche Dienste beteiligt sind,
welche Daten wohin fließen, wie Zugriff geprüft wird, wo Zugangsdaten liegen, welche
Fremdbibliotheken verwendet werden. Kurz genug, dass jemand es in zehn Minuten liest, und
konkret genug, dass er es beurteilen kann.

Halt das Ergebnis im `PLAN.md` fest — was gefragt wurde, wer geantwortet hat, was vereinbart
ist. Beim nächsten Personalwechsel weiß es sonst niemand mehr.
