# Bauregeln

Wende diese Regeln beim Bauen an, ohne sie zu erklären. Sie sind die Antwort darauf, wie
KI-gebaute Software regelmäßig auffliegt: Zugangsdaten im Code, Zugriffsprüfung nur in der
Oberfläche, Datenbank offen im Netz.

## Immer, auch beim schnellsten POC

**Zugangsdaten leben in `.env`, niemals im Code.** Kein Schlüssel als Zeichenkette, auch nicht
"nur zum Testen" — Testschlüssel bleiben drin und landen in Git. `.env` gehört in `.gitignore`,
`.env.beispiel` mit leeren Feldern kommt mit ins Repository.

**Ein einmal veröffentlichter Schlüssel bleibt veröffentlicht.** Ihn aus der Datei zu löschen
genügt nicht — er steht weiter in der Versionsgeschichte. Zwei Wege, und der erste ist fast
immer der richtige: **Schlüssel beim Anbieter neu ausstellen**, dann ist der alte wertlos, egal
wo er noch steht. Zusätzlich lässt sich die Geschichte bereinigen: Bei einem einzelnen, noch
nicht hochgeladenen Stand reicht `git commit --amend`; ist schon hochgeladen worden, ist das
Aufräumen aufwendig und der neue Schlüssel umso wichtiger.

**Was im Browser läuft, ist öffentlich.** Alles, was der Browser lädt, kann jeder Besucher
lesen — Minifizierung ändert daran nichts. In den Browser gehören nur Schlüssel, die
ausdrücklich für die Öffentlichkeit gedacht sind (bei Supabase der `anon key`, niemals der
`service_role key`).

**Zugriff wird auf dem Server geprüft, nicht in der Oberfläche.** Einen Knopf auszublenden ist
keine Sicherheit — die zugehörige Anfrage lässt sich trotzdem stellen. Jede Anfrage, die Daten
liest oder ändert, prüft serverseitig: *Ist die Person angemeldet, und darf ausgerechnet sie an
ausgerechnet diesen Datensatz?* Die zweite Hälfte wird am häufigsten vergessen.

**Eingaben nie direkt in Abfragen einsetzen.** Immer parametrisierte Abfragen oder ein ORM.
Zeichenketten zusammenkleben ist der direkte Weg zu SQL-Injection.

**Jede Eingabe wird auf dem Server geprüft, bevor sie irgendetwas anfasst.** Für jeden Endpunkt
ein Bauplan der erwarteten Daten — welche Felder, welcher Typ, welche Länge, welches Format —,
und was nicht dazu passt, wird abgewiesen. Prüfungen im Formular sind Bequemlichkeit für den
Nutzer, keine Sicherheit: die Anfrage lässt sich am Formular vorbei stellen. Zwei Fallen dabei:
**Übernimm nie einfach das ganze Eingabepaket in den Datensatz** — sonst schickt jemand ein Feld
mit, das er nie ausfüllen durfte (`rolle: admin`, `freigeschaltet: true`), und es wird
mitgespeichert. Übernimm die Felder einzeln und benannt. Und **begrenz die Größe der Anfrage**,
sonst kann man den Server mit einem einzigen riesigen Paket beschäftigen.

**Die Sperre gegen versehentliches Mitspeichern bleibt scharf.** Jedes Projekt bekommt beim
Anlegen eine Prüfung, die Commits mit Zugangsdaten oder echten Daten blockiert. Sie mit
`--no-verify` zu umgehen ist nie die Lösung — wenn sie anschlägt, hat sie recht.

**Von Anfang an in Git**, mit kleinen Schritten. Das ist die Rückfahrkarte, wenn etwas
kaputtgeht — und der einzige Grund, warum man beim Bauen mutig sein darf.

## Sobald andere Menschen drankommen

**Login über einen fertigen Dienst**, nie selbst gebaut. Supabase Auth, Auth0, Clerk. Passwort-
Hashing, Zurücksetzen, Sitzungsverwaltung selbst zu bauen geht fast immer schief.

**Der Besitzer-Test gehört zur Abnahme, nicht zur Kür.** Sobald es zwei Nutzer geben kann,
gibt es einen Test, der es darauf anlegt: *Nutzer A meldet sich an und versucht, den Datensatz
von Nutzer B zu lesen und zu ändern.* Er muss scheitern, und zwar serverseitig. Dieser Test ist
der Beweis; ohne ihn ist die Zugriffsprüfung eine Behauptung. Er läuft bei jeder Änderung mit,
damit der Fehler nicht zurückkommen kann.

**Rollen von Anfang an mitdenken**, auch wenn es zunächst nur zwei gibt. Nachträglich ein
Rollenmodell in eine gewachsene Anwendung zu ziehen ist teuer.

**Bremse am Login.** Ohne Begrenzung kann jemand Passwörter im Sekundentakt durchprobieren.
Zehn Versuche, dann eine Pause.

**Die Bremse gilt nicht nur am Login.** Jeder Endpunkt, der schreibt, verschickt oder Geld
kostet, bekommt eine Begrenzung pro Nutzer und pro Adresse. Sonst genügt ein Skript, um die
Anwendung lahmzulegen oder eure Rechnung hochzutreiben.

**Die Sitzung gehört in ein Cookie, nicht in den Browser-Speicher.** Ein Anmelde-Token in
`localStorage` kann jedes eingeschleuste Skript auslesen und mitnehmen. Richtig ist ein Cookie
mit drei Eigenschaften: `httpOnly` (für Skripte unlesbar), `secure` (nur über verschlüsselte
Verbindung), `sameSite` (geht nicht bei Anfragen von fremden Seiten mit). Und: Beim Abmelden
wird die Sitzung serverseitig ungültig, nicht nur das Cookie im Browser gelöscht.

**Cookie-Anmeldung braucht einen Schutz gegen untergeschobene Anfragen.** Wenn der Browser das
Anmelde-Cookie automatisch mitschickt, kann eine fremde Webseite im Namen der angemeldeten
Person eine Aktion auslösen (Cross-Site Request Forgery). `sameSite` deckt den Normalfall ab;
bei allem, was ändert oder löscht, kommt ein Anfrage-Token dazu. Fertige Login-Dienste bringen
das mit — wer selbst Formulare gegen eigene Endpunkte schickt, muss es einschalten.

**Wer von außen anfragen darf, wird aufgezählt.** Die Erlaubnis für fremde Herkunft (CORS) steht
auf genau euren Adressen — niemals auf `*`, erst recht nicht zusammen mit Anmeldedaten.
`Access-Control-Allow-Origin: *` ist der Schalter, den man beim Entwickeln umlegt, weil es sonst
nicht läuft, und der dann drinbleibt. Er gehört vor dem Livegang zurückgestellt.

**Fehlermeldungen verraten nichts.** "Anmeldung fehlgeschlagen" — nicht "Passwort falsch"
(das bestätigt, dass die Mailadresse existiert). Keine technischen Details nach außen.

## Sobald personenbezogene Daten drin sind

**Lösch- und Exportfunktion gehören zur ersten Version.** Nicht wegen der Vorschrift, sondern
weil beides nachträglich schwer ist, wenn Daten über Tabellen verstreut sind.

**Nur speichern, was gebraucht wird.** Jedes Feld, das man nicht hat, kann nicht verloren gehen.

**Wer hat was wann geändert** — ein einfaches Protokoll bei kritischen Daten. Das ist die
Fähigkeit, hinterher überhaupt sagen zu können, was passiert ist.

## Sobald KI eingebaut ist

**Jede Route, die ein Modell aufruft, ist angemeldet und begrenzt.** Ein offener Endpunkt,
hinter dem ein KI-Schlüssel liegt, ist eine Bezahlschnittstelle, die auf eure Rechnung läuft —
und sie wird gefunden, ohne dass jemand es auf euch abgesehen hat. Drei Dinge gehören an jede
solche Route: Anmeldung, eine Begrenzung **pro Nutzer** (nicht nur insgesamt, sonst blockiert
ein einzelner alle anderen) und eine Obergrenze für die Länge der Eingabe. Ohne die Längengrenze
kostet ein einziger Aufruf beliebig viel.

**Ausgabenlimit vor dem ersten Aufruf.** Beim Anbieter im Konto, nicht nur im Code — ein
Tageslimit und eine Warnung, die bei einem Bruchteil davon anschlägt. Der Code kann sich irren,
das Konto nicht. Eine Schleife, die versehentlich tausendmal aufruft, ist ein normaler
Programmierfehler.

**Der Agent darf nur, was er muss.** Wenn eine KI Daten lesen soll, gib ihr keinen Schreibzugriff.
Das ist die häufigste Schwachstelle in KI-Anwendungen überhaupt.

**Was Nutzer eingeben, ist Text und niemals Anweisung.** Wenn fremde Inhalte in einen Prompt
fließen — Mails, Dokumente, Webseiten — dürfen darin enthaltene Aufforderungen nicht befolgt
werden. Trenn Anweisung und Material deutlich.

**Ein Hinweis in der Oberfläche, dass hier eine KI antwortet.** Eine Zeile.

## Stack-spezifisch

**Supabase:** Row Level Security ist bei neuen Tabellen **nicht** automatisch an. Ohne sie ist
die Tabelle über die öffentliche Schnittstelle frei abrufbar — genau der Fehler, der bei 10 %
von 1.645 geprüften Lovable-Projekten Kundendaten offengelegt hat. Für **jede** Tabelle:
`alter table <name> enable row level security;` plus Regeln, die den eigenen Datensatz
freigeben. Eine abgesicherte Tabelle und neun offene sehen im Code fast gleich aus — zähl sie
durch: jede Tabelle, die angelegt wurde, braucht ihre eigene Zeile. Danach mit dem `anon key`
gegenprüfen, dass ohne Login nichts kommt.

**Next.js / Vercel:** Nur Variablen mit `NEXT_PUBLIC_` landen im Browser — alles andere bleibt
serverseitig. Umgekehrt heißt das: Setz dieses Präfix niemals vor einen echten Schlüssel.

**Datei-Uploads:** Dateityp und Größe serverseitig prüfen, Dateinamen neu vergeben, nicht im
Web-Wurzelverzeichnis ablegen. Hochgeladene Dateien sind fremder Code, bis das Gegenteil
bewiesen ist.

## Angriffsfläche klein halten

**Nur die Anwendung selbst ist öffentlich erreichbar.** Datenbank, Admin-Oberfläche und
Server-Zugang gehören nie ins offene Netz — auch nicht "kurz zum Testen". Wer intern arbeiten
kann, arbeitet intern; von außen nur über VPN.

**Das Code-Verzeichnis steht auf privat.** Bei GitHub ist "public" die Voreinstellung, wenn man
nicht aufpasst. Prüf das aktiv: `gh repo view --json visibility`.

**Sicherheits-Header setzen**, sobald etwas öffentlich erreichbar ist: HSTS (erzwingt
verschlüsselte Verbindungen), Content-Security-Policy (verhindert eingeschleusten Fremdcode),
Anti-Framing (verhindert, dass die Seite unsichtbar in eine fremde eingebettet wird).
Zertifikate über Let's Encrypt automatisch erneuern lassen — abgelaufene Zertifikate sind der
häufigste selbstverschuldete Ausfall.

## Ausgaben maskieren

Alles, was ein Nutzer eingegeben hat und später wieder angezeigt wird, muss beim Anzeigen
maskiert werden. Sonst kann jemand statt eines Namens ein Stück Programmcode eintragen, das im
Browser der nächsten Person ausgeführt wird (Cross-Site-Scripting). Moderne Oberflächen-Werkzeuge
tun das von selbst — solange man sie nicht mit Funktionen wie `dangerouslySetInnerHTML` oder
`v-html` umgeht. Tu das nicht.

## Mandantentrennung

Sobald mehrere Firmen, Abteilungen oder Standorte dieselbe Anwendung benutzen: Jeder Datensatz
trägt eine Kennung, zu wem er gehört, und die Trennung wird **in der Datenbank** erzwungen, nicht
nur im Programmcode. Der Grund: Programmcode hat viele Wege zu den Daten, und einer davon wird
irgendwann die Prüfung vergessen. Die Datenbank hat nur einen.

Und bau dafür einen Test, der genau das versucht: *Kann Mandant A einen Datensatz von Mandant B
abrufen?* Wenn dieser Test bei jeder Änderung mitläuft, kann dieser Fehler nicht zurückkommen.

## Sobald Geld oder fremde Systeme im Spiel sind

**Was etwas kostet, bestimmt der Server.** Preis, Menge, Rabatt und Währung werden auf dem Server
aus den eigenen Daten geholt — niemals aus dem übernommen, was der Browser mitschickt. Sonst
ändert jemand den Betrag auf dem Weg. Der Browser schickt, *was* gekauft wird, nicht *was es
kostet*.

**Rückmeldungen fremder Dienste werden auf Echtheit geprüft.** Ein Webhook — die Zeile, mit der
Stripe meldet „bezahlt" oder ein anderes System „fertig" — ist eine Adresse, die jeder kennen
kann. Ohne Prüfung der mitgelieferten Signatur kann jeder eine Zahlung melden, die nie
stattgefunden hat. Jeder Anbieter liefert dafür ein Geheimnis und eine fertige Prüffunktion;
die wird benutzt, bevor irgendetwas anderes passiert. Zusätzlich: dieselbe Meldung kann
mehrfach ankommen — jede Meldung bekommt eine Kennung und wird nur einmal verarbeitet.

## Schlüssel für Schnittstellen

Ein Schlüssel pro angebundenem System, nie ein universeller für alles. Jeder mit Ablaufdatum
und einzeln sperrbar — damit man einen zurückziehen kann, ohne alles andere lahmzulegen.
Zusätzlich eine Begrenzung, wie oft er pro Minute benutzt werden darf.

## Betriebs-Hygiene vor dem Livegang

Kurz durchgehen, das sind die Klassiker:

- Debug- und Entwicklermodus abgeschaltet (sonst zeigen Fehlerseiten interne Details)
- Standard-Passwörter geändert — Datenbank, Admin-Konten, alles aus Anleitungen Kopierte
- Fehlermeldungen nach außen sind allgemein gehalten, technische Details bleiben im Protokoll
- Keine Zugangsdaten und keine vollständigen Personendaten in den Protokollen
- Admin-Bereich nur intern erreichbar oder mit zweitem Faktor
- CORS steht auf euren eigenen Adressen, nicht auf `*`
- Anmelde-Cookies mit `httpOnly`, `secure` und `sameSite`
- Jemand ist benannt, der Aktualisierungen einspielt — und weiß, dass er es ist

## Was protokolliert wird

Nicht alles, aber das Richtige. **Hinein gehören:** Anmeldungen, erfolgreich wie gescheitert ·
Passwortänderungen · jede schreibende Aktion mit Wer, Wann, Was und welcher Datensatz ·
abgelehnte Zugriffe · Änderungen an Rechten. **Nicht hinein gehören:** Passwörter, Schlüssel,
vollständige Personendaten. Aufbewahrung mindestens 90 Tage — vorher merkt man einen Vorfall
oft gar nicht.

Der Sinn ist nicht Kontrolle, sondern die Fähigkeit, hinterher überhaupt sagen zu können, was
passiert ist.

## Merken, wenn etwas kaputt ist

Ab MVP: ein Prüfpunkt in der Anwendung, der meldet, ob sie und ihre Datenbank erreichbar sind,
und ein externer Dienst, der diesen Punkt regelmäßig abruft. Alarm an eine **benannte Person**
bei: Anwendung nicht erreichbar · Festplatte voll · Zertifikat läuft bald ab · letztes Backup
zu alt · auffällig viele gescheiterte Anmeldungen.

Ein Alarm, der an niemanden geht, ist kein Alarm.

## Backups nach der 3-2-1-Regel

Drei Kopien, zwei verschiedene Orte, eine davon außer Haus. Gesichert werden Datenbank,
hochgeladene Dateien und die Konfiguration — die Zugangsdaten getrennt davon. Verschlüsselt.

Und einmal im Quartal eine Wiederherstellung tatsächlich durchspielen, mit dem Datum im
`PLAN.md`. Ein Backup, das nie zurückgespielt wurde, ist eine Vermutung. Dazu eine Anleitung,
die auch jemand befolgen kann, der das Projekt nicht gebaut hat.

## Daten-Ampel für externe Dienste

Bevor Daten an einen fremden Dienst gehen — KI-Anbieter, Mailversand, Auswertung —, ordne sie
ein:

- **Grün:** unkritisch, jedes Werkzeug ist erlaubt
- **Gelb:** nur bei Anbietern mit Vertrag und in der EU
- **Rot:** verlässt das Haus nicht

Diese Einordnung gehört ins `PLAN.md`, damit sie beim nächsten neuen Dienst nicht neu erfunden
wird.

## Was der bauende Agent selbst darf

Diese Regeln gelten nicht für die gebaute Software, sondern für **Claude Code beim Bauen**.
Sie werden übersehen, weil sie so nah dran sind.

**Der Arbeitsbereich bleibt der Projektordner.** Nicht das ganze Benutzerverzeichnis, nicht
Netzlaufwerke. Wenn eine Aufgabe darüber hinausführt, ist das eine bewusste Entscheidung, keine
Nebensache.

**Echte Daten zum Testen ja — aber nur in `daten/`.** Ohne echte Daten beweist ein Test oft
nichts, deshalb gehören sie dazu. Der Fallstrick ist nicht die Datei, sondern wohin sie wandert:
Wer eine Excel-Liste mit echten Adressen irgendwo im Projektordner ablegt, hat sie beim nächsten
Hochladen mit veröffentlicht. Deshalb hat jedes Projekt den Ordner `daten/`, der von Git
ausgeschlossen ist — dort hinein und nirgendwo sonst. Und nach dem Test wieder heraus.

**Zugang zum Testsystem, nie zum Produktivsystem.** Ein Agent mit Schreibrechten auf der
laufenden Datenbank ist ein Risiko ohne Gegenwert — was er dort tun soll, kann er auch als
geprüfte Änderung tun.

**Volle Rechte nur in Wegwerf-Umgebungen.** Der Modus, in dem nicht mehr nachgefragt wird, ist
für Container und Testrechner gedacht. Auf dem Arbeitsrechner mit Firmenzugängen ist er es
nicht. Dass gefragt wird, bevor etwas gelöscht oder verschickt wird, ist die Funktion und nicht
die Störung.

**Kritische Aktionen brauchen einen Menschen.** Alles, was nach außen wirkt — Mails versenden,
Daten löschen, veröffentlichen, bezahlen —, wird vorgelegt und nicht selbstständig ausgeführt.
Das gilt für den bauenden Agenten wie für den, den man baut.
