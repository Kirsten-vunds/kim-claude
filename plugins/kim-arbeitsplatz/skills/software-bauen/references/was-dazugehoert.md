# Was dazugehört, aber niemand sieht

Wer noch nie Software gebaut hat, stellt sich vor, was er **sieht** — die Oberfläche. Was
dahinter liegt, kann man nicht ahnen, wenn man es nie gebraucht hat. Das ist kein Wissensmangel,
das ist die Natur der Sache: Bei einem Auto sieht man auch nur das Lenkrad.

Dein Job ist, das Unsichtbare **einmal kurz sichtbar zu machen** — nicht als Warnung, sondern
als Selbstverständlichkeit, um die du dich kümmerst.

## Wie du es sagst

Drei Sätze, in dieser Reihenfolge, dann weiter im Text:

1. **Was zusätzlich dazugehört** — in einem Satz, ohne Fachbegriffe.
2. **Dass es kein Problem ist** — du kümmerst dich, das ist Routine.
3. **Warum sie es trotzdem wissen sollte** — weil es Geld kostet, eine Entscheidung nach sich
   zieht oder später jemand danach fragt.

> "Klar, machen wir. Eine Sache, die man von außen nicht sieht: So ein Chatbot antwortet nicht
> selbst — dahinter muss ein Sprachmodell laufen, so wie ChatGPT eines ist. Das organisiere ich,
> ist kein Aufwand. Wissen solltest du nur zweierlei: Es kostet pro Antwort ein paar Cent, und
> wir müssen uns kurz überlegen, welches wir nehmen — da hängt dran, wo eure Daten
> hinlaufen."

Was du **nicht** tust: eine Liste von zwölf Dingen aufzählen, die auch noch nötig sind. Das
lähmt. Nenn das eine, das die Person wirklich betrifft, und behalt den Rest für den Plan.

---

## Chatbot oder KI-Assistent

**Was man sich vorstellt:** ein Chatfenster.

**Was dazugehört:** Das Chatfenster ist der kleinste Teil. Dahinter braucht es ein
**Sprachmodell**, das die Antworten erzeugt — die Anwendung selbst kann das nicht. Das heißt:
ein Konto beim Anbieter, ein Schlüssel, und Kosten pro Antwort.

Der Aufruf des Sprachmodells muss **auf dem Server** passieren, nie im Browser. Sonst steht der
Schlüssel in der Seite und jeder Besucher kann auf fremde Rechnung Anfragen stellen. Das ist der
häufigste teure Fehler bei selbstgebauten Chatbots.

Dazu: ein Ausgabenlimit beim Anbieter, bevor der erste Aufruf läuft. Und wenn der Bot auf
**eigene Unterlagen** antworten soll — Handbücher, Preislisten, Protokolle —, ist das ein
zweites Vorhaben: Die Dokumente müssen aufbereitet und durchsuchbar abgelegt werden, damit das
Modell die passenden Stellen dazubekommt. Das ist der eigentliche Aufwand, nicht der Chat.

**Entscheidungen, die daran hängen:** welches Modell (bestimmt, wohin die Daten laufen — in die
USA oder in die EU), was passiert, wenn der Bot etwas erfindet, und wer die Antworten prüft,
bevor sie an Kunden gehen.

**Was ehrlich gesagt werden muss:** Ein Chatbot, der auf Kunden losgelassen wird, ist kein POC.
Der antwortet im Namen der Firma.

## Website, auf der sich jemand anmeldet

**Was man sich vorstellt:** ein Feld für Mail und Passwort.

**Was dazugehört:** Anmelden ist ein ganzes Teilsystem. Registrierung, Passwort vergessen,
Sitzungen, die irgendwann ablaufen, Sperren nach zu vielen Fehlversuchen — und ein
**Mailversand**, der funktioniert, sonst kommt die Bestätigungsmail nie an. Damit die nicht im
Spam landet, muss die Absenderadresse beim Domänen-Anbieter freigeschaltet werden; das macht
meist die IT.

Deshalb bauen wir Login nie selbst, sondern nehmen einen fertigen Dienst. Nicht aus
Bequemlichkeit — an dieser Stelle haben selbstgebaute Lösungen die meisten Lücken.

**Und die zweite Hälfte, die fast immer fehlt:** Angemeldet zu sein heißt nicht, alles sehen zu
dürfen. Für jeden einzelnen Datensatz muss geprüft werden, ob **diese** Person **ihn** sehen
darf. Das ist der Unterschied zwischen "eingeloggt" und "berechtigt".

## "Eine App"

**Was man sich vorstellt:** ein Symbol auf dem Handy.

**Was dazugehört:** In neun von zehn Fällen ist das Richtige eine Website, die auf dem Handy
gut aussieht — Link oder QR-Code, fertig, sofort für alle aktualisiert.

Eine echte App aus dem Store bedeutet: Entwicklerkonten bei Apple und Google (jährliche
Gebühren), ein Freigabeverfahren, das Tage dauert und auch abgelehnt werden kann, und jede
Korrektur muss erneut durch dieses Verfahren. Für ein internes Werkzeug lohnt sich das fast
nie.

**Der Satz dazu:** *"Das bauen wir als Seite, die auf dem Handy läuft — ihr öffnet sie über
einen Link oder QR-Code. Eine richtige App im Store hieße Entwicklerkonten und ein
Freigabeverfahren bei Apple, und jede kleine Änderung müsste da wieder durch. Falls ihr später
wirklich in den Store wollt, geht das immer noch."*

## Auswertung oder Dashboard

**Was man sich vorstellt:** hübsche Diagramme.

**Was dazugehört:** Die Diagramme sind eine Stunde Arbeit. Der Aufwand steckt darin, **woher
die Zahlen kommen** — verlässlich, aktuell, in gleicher Form. Wenn sie aus einem anderen System
stammen, braucht es dort eine Schnittstelle. Gibt es die nicht, ist das Vorhaben ein anderes,
als es aussah.

**Frag früh:** Woher kommen die Zahlen heute, wer pflegt sie, und wie oft müssen sie aktuell
sein? Bei "einmal am Tag reicht" ist vieles einfach, bei "in Echtzeit" wird es ein anderes
Projekt.

## Dokumente auswerten (Rechnungen, Lieferscheine, PDFs)

**Was man sich vorstellt:** Datei rein, Daten raus.

**Was dazugehört:** Bei sauberen digitalen PDFs geht das gut. Bei **gescannten** Dokumenten
muss der Text erst aus dem Bild gelesen werden, und die Qualität schwankt mit der Vorlage —
schiefe Scans, Stempel, Handschrift. Rechne mit Fehlern und plan von Anfang an ein, dass ein
Mensch die Ergebnisse bestätigt, bevor sie weiterlaufen. Das ist keine Schwäche des Werkzeugs,
sondern die richtige Bauweise.

**Und die Frage, die niemand stellt:** Wohin gehen die Dokumente zur Auswertung? Wenn ein
KI-Dienst sie verarbeitet, verlassen sie das Haus. Bei Rechnungen mit Kundendaten ist das eine
Entscheidung, keine Nebensache — Daten-Ampel im Plan.

**Der ehrliche Satz:** *"Wir schauen uns das an zehn echten Dokumenten von euch an, bevor wir
weiterbauen. Wenn eure Scans gut sind, wird das einfach. Wenn nicht, wissen wir es nach einer
halben Stunde statt nach zwei Wochen."*

## Formular auf der Website

**Was man sich vorstellt:** ein paar Felder und ein Absenden-Knopf.

**Was dazugehört:** Ein offenes Formular im Internet wird von Maschinen zugemüllt — es braucht
einen Spam-Schutz. Die Benachrichtigungsmail braucht dieselbe Freischaltung wie oben, sonst
landet sie im Spam. Die Eingaben müssen irgendwo gespeichert werden, nicht nur verschickt. Und
wenn personenbezogene Daten erhoben werden, gehören ein Hinweis und eine Zustimmung dazu.

## "Das soll sich mit unserem System verbinden"

**Was man sich vorstellt:** die beiden Systeme reden miteinander.

**Was dazugehört:** Das geht nur, wenn das andere System eine Schnittstelle hat — und die ist
oft gar nicht vorhanden, kostet extra oder muss vom Hersteller freigeschaltet werden. Das ist
der häufigste Grund, warum solche Vorhaben scheitern, und man merkt es am billigsten **vor**
dem Bauen.

**Frag als Erstes:** Wie heißt das System genau, und weiß jemand, ob es eine Schnittstelle hat?
Bau notfalls zuerst ohne Anbindung und mit einem Export als Tabelle — das funktioniert immer und
nimmt dem Vorhaben das Risiko.

## Zahlungen

**Was man sich vorstellt:** ein Bezahlen-Knopf.

**Was dazugehört:** Zahlungsdaten fasst du nicht an. Das übernimmt ein Anbieter wie Stripe, der
dafür geprüft ist — der Bezahlvorgang läuft bei ihm, nicht bei uns. Dazu kommen
Widerrufsbelehrung, AGB und Preisangaben; das ist kein Code, sondern muss von jemandem kommen,
der sich damit auskennt.

---

## Die stille Grundregel

Bei allem oben gilt dasselbe Muster: **Was man sieht, ist der kleinere Teil.** Wenn eine Person
ihr Vorhaben in einem Satz beschreibt und du merkst, dass ein unsichtbares Stück fehlt — sag es
sofort, kurz, und mit dem Angebot, dass du dich darum kümmerst. Wer das erst beim Bauen erfährt,
hat das Gefühl, es sei etwas schiefgegangen. Wer es am Anfang hört, lernt etwas.
