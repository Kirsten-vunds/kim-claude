# Hinweise für Claude — {{NAME}}

Dieses Projekt wurde mit dem Skill `software-bauen` angelegt und wird von jemandem ohne
Programmierhintergrund betreut. Diese Datei wird automatisch geladen, sobald in diesem Ordner
gearbeitet wird — sie hält das Projekt in Ordnung, ohne dass jemand daran denken muss.

**Projektbegleitung: an**

*(Wer das für eine Sitzung nicht will, ändert das auf "aus" oder sagt es einfach — dann
entfällt die Pflege der drei Dateien. Standard ist an, denn ein Projekt ohne gepflegtes
Gedächtnis ist nach der dritten Sitzung nicht mehr fortsetzbar.)*

## Zu Beginn jeder Sitzung

1. `PLAN.md` lesen — was das Ding ist, wie es gebaut ist, welche Sicherheitsvorgaben gelten.
2. `TODO.md` lesen — was offen ist und womit angefangen wird.
3. `VERLAUF.md` lesen — der oberste Eintrag sagt, wo es zuletzt stand.
4. `bash {{SKILLPFAD}}/scripts/sicherheits-check.sh` laufen lassen, bevor du
   etwas änderst. Abhängigkeiten veralten und Zugangsdaten rutschen versehentlich in den Code —
   beides fällt so auf, bevor es teuer wird.

Sag danach in zwei, drei Sätzen, wo das Projekt steht und was du als Nächstes vorschlägst.
Die Person hat womöglich drei Wochen nicht hineingeschaut.

## Am Ende jeder Sitzung

Diese drei Dateien sind die einzige Erinnerung, die das Projekt hat:

- **`VERLAUF.md`**: neuer Eintrag oben — was gemacht wurde, was als Nächstes dran ist, was hakt.
- **`TODO.md`**: Erledigtes abhaken, Neues aufnehmen, den Startpunkt für die nächste Sitzung
  ganz oben eintragen.
- **`PLAN.md`**: nur bei Grundsätzlichem — neue Schnittstelle, geänderter Aufbau, neue
  Sicherheitsvorgabe. Jede solche Änderung zusätzlich als Zeile in die Tabelle "Entscheidungen
  und warum", mit Datum und Grund.

Das gilt auch, wenn die Sitzung kurz war oder nichts fertig wurde — gerade dann.

## Beim Arbeiten

- In Alltagssprache erklären, keine Fachbegriffe ohne Übersetzung.
- Technische Entscheidungen selbst treffen, kurz begründen, Veto ermöglichen — nicht zur
  Abstimmung stellen. Fachliche Fragen dagegen jederzeit stellen.
- In kleinen Schritten bauen und Ergebnisse **zeigen**, statt lange stillschweigend zu arbeiten.
- **Git führst du allein.** Nach jedem funktionierenden Schritt und vor jedem größeren Umbau
  einen Stand sichern — ohne zu fragen, mit einer Beschreibung, die die Person lesen kann
  ("Formular speichert jetzt auch ohne Telefonnummer"). Keine Fachbegriffe im Gespräch, keine
  Git-Probleme nach außen tragen. Stände anzeigen oder zurückgehen:
  `bash {{SKILLPFAD}}/scripts/staende.sh`
- Zugangsdaten gehören in `.env`, niemals in den Code und niemals in den Browser-Teil.
- Zugriffsprüfung immer auf dem Server, nie nur in der Oberfläche.
- Nach jeder Änderung an Daten, Zugriff oder Konfiguration: Sicherheits-Check laufen lassen.
- Vor jedem Livegang: `sicherheits-check.sh --url <adresse>` — der Test von außen.

## Den Skill heranziehen

Für alles, was über eine kleine Änderung hinausgeht — neue Funktion, Umbau, Livegang,
Sicherheitsfrage —, nutze den Skill `software-bauen`. Er enthält das Vorgehen, die
Baurichtlinien (`references/bauregeln.md`), die Prüfskripte und den Gesprächsleitfaden.

Die Pflege der drei Dateien oben läuft dagegen **immer**, auch ohne den Skill: Diese Datei
wird bei jedem Start in diesem Ordner geladen, und das genügt.
