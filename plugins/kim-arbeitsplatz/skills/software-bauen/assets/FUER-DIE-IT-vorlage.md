# {{NAME}} — Übersicht für die IT

*Stand {{DATUM}}. Dieses Dokument richtet sich als einziges im Projekt an Fachleute. Es soll in
zehn Minuten lesbar und beurteilbar sein — bei Rückfragen bitte an die im Plan genannte
Ansprechperson.*

## Was die Anwendung tut

<Zwei Sätze. Zweck, Nutzerkreis, ungefähre Nutzerzahl.>

## Reifegrad

<POC / MVP / Produktiv> — <erreichbar von wo, seit wann, geplante Lebensdauer>

## Was wo läuft

| Bestandteil | Technik | Wo es läuft | Anbieter / Standort |
|---|---|---|---|
| Oberfläche | | | |
| Anwendungslogik | | | |
| Datenbank | | | |
| Dateiablage | | | |

## Erreichbarkeit

- **Adressen:** <Domänen / interne Namen>
- **Von wo erreichbar:** <nur lokal / Firmennetz / Internet>
- **Verschlüsselung:** <TLS, Zertifikatsherkunft, HSTS ja/nein>
- **Offene Ports nach außen:** <nur 443, oder Liste>

## Anmeldung und Berechtigungen

- **Anmeldeverfahren:** <Anbieter, SSO ja/nein, 2FA ja/nein>
- **Rollen:** <Aufzählung>
- **Wo die Berechtigung geprüft wird:** <serverseitig, an welcher Stelle; bei Datenbanken mit
  Zeilenschutz: welche Regeln>
- **Mandantentrennung:** <nötig ja/nein, wie erzwungen>

## Daten

| Datenart | Personenbezug | Wo gespeichert | Aufbewahrung |
|---|---|---|---|
| | | | |

- **Löschung und Export für Betroffene:** <vorhanden / nicht nötig, weil …>
- **Verschlüsselung ruhender Daten:** <ja/nein, wodurch>

## Externe Dienste und Datenflüsse

| Dienst | Wofür | Welche Daten gehen dorthin | Standort | Vertrag |
|---|---|---|---|---|
| | | | | |

## Zugangsdaten

- **Wo sie liegen:** <Umgebungsvariablen / Secret-Verwaltung des Anbieters>
- **Nicht im Code, nicht im Browser-Teil, nicht in der Versionsverwaltung** — geprüft am
  <Datum> durch den automatischen Check
- **Wer sie kennt:** <Personen oder Rollen>

## Fremdbibliotheken

- **Wie viele direkte Abhängigkeiten:** <Zahl>
- **Letzte Sicherheitsprüfung:** <Datum, Ergebnis>
- **Wie aktualisiert wird:** <Rhythmus, wer>

## Protokollierung und Überwachung

- **Was protokolliert wird:** <Anmeldungen, schreibende Aktionen, abgelehnte Zugriffe>
- **Was ausdrücklich nicht:** Zugangsdaten, vollständige Personendaten
- **Aufbewahrung:** <Dauer>
- **Alarmierung:** <woran, an wen>

## Sicherung und Wiederherstellung

- **Was gesichert wird, wie oft, wohin:** <…>
- **Verschlüsselt:** <ja/nein>
- **Letzter erfolgreicher Wiederherstellungstest:** <Datum>

## Betrieb

- **Wer betreibt es:** <Name oder Rolle>
- **Wie eine neue Version live geht:** <Weg in einem Satz>
- **Wie zurückgerollt wird:** <Weg in einem Satz>
- **Quellcode liegt:** <Adresse, öffentlich/privat, wem das Konto gehört>

## Bekannte offene Punkte

*Ehrlich. Was bewusst weggelassen wurde und wann es nachgeholt wird — aus `TODO.md`.*

- <Punkt> — <geplant für>
