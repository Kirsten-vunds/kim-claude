# Recht — nur was den Bau betrifft

Diese Datei ist zum Nachschlagen, wenn jemand ausdrücklich fragt. Zieh sie nicht ungefragt ins
Gespräch — sie hält den Bau auf, und die meisten Punkte sind später erledigbar.

**Kein Ersatz für Rechtsberatung.** Alles hier ist Orientierung, keine Auskunft.

## Was tatsächlich in den Code muss

| Wann | Was gebaut wird |
|---|---|
| Personenbezogene Daten (Namen, Mail, Telefon, alles Zuordenbare) | Löschfunktion, Datenexport, Verschlüsselung der Verbindung, Zugriff nur für Berechtigte |
| Sichtbarer KI-Einsatz gegenüber Menschen | Ein Hinweis in der Oberfläche, dass hier eine KI antwortet (EU AI Act Art. 50, gilt ab 02.08.2026) |
| Erfassung von Mitarbeiterverhalten | Vor dem Rollout mit dem Betriebsrat klären (§ 87 Abs. 1 Nr. 6 BetrVG) — sonst darf das Tool nicht eingesetzt werden, egal wie gut es ist |

Die ersten beiden sind Bauaufgaben und werden einfach gemacht. Die dritte ist die einzige, die
ein Projekt wirklich stoppen kann — deshalb früh ansprechen, wenn es um ein Werkzeug geht, mit
dem Arbeit von Kolleginnen sichtbar wird.

## Was als Notiz reicht

Ins PLAN.md unter "Mit jemandem klären, der sich auskennt", ohne das Gespräch aufzuhalten:

- **Verarbeitungsverzeichnis** — die Anwendung muss in die Liste des Unternehmens (DSGVO Art. 30).
  Reine Verwaltungsaufgabe, kein Code.
- **Auftragsverarbeitungsvertrag** mit jedem Anbieter, bei dem personenbezogene Daten liegen
  (Hosting, Datenbank, KI-Dienst). Die Anbieter haben Standardverträge zum Anklicken.
- **Datenschutzerklärung**, sobald Externe die Anwendung benutzen.
- **Datenschutz-Folgenabschätzung**, wenn es um sensible Daten oder systematische Beobachtung
  geht (Art. 35). Selten bei internen Werkzeugen.

## Was oft irrelevant ist — nicht ungefragt aufmachen

- **Barrierefreiheit (BFSG)** greift bei Angeboten an Verbraucher mit Vertragsabschluss —
  Shop, Buchung. Interne Werkzeuge sind nicht betroffen.
- **Cyber Resilience Act** greift, wenn Software als Produkt an Dritte vertrieben wird.
  Wer für sich selbst baut, ist raus.
- **NIS2** trifft größere Unternehmen in bestimmten Branchen direkt. Indirekt kann es über
  Kundenverträge durchschlagen — dann fragt aber der Kunde, nicht wir.

## Wo die Daten liegen

Frag nicht nach Rechtsgrundlagen, sondern wähl gleich europäische Regionen — bei Supabase
Frankfurt, bei Vercel eine EU-Region. Das erledigt die häufigste Rückfrage der IT-Abteilung,
bevor sie gestellt wird, und kostet nichts.
