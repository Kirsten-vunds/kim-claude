# Gesprächsleitfaden

Die sechs Einstiegsfragen aus dem SKILL.md sind der Rahmen. Hier steht, was hinter jeder von
ihnen steckt — für den Fall, dass das Gespräch in die Tiefe geht oder du merkst, dass ein
Punkt den Bau wirklich verändert.

**Wie du das benutzt:** Nicht vorlesen. Jeder Punkt ist markiert:

- **Fragen**, wenn das Projekt es hergibt — die Antwort ändert, was gebaut wird.
- **Selbst entscheiden** — du legst fest und sagst es in einem Satz.
- **Später** — gehört ins `TODO.md`, nicht ins Gespräch.

Bei einem POC bleibt fast alles bei "selbst entscheiden". Je näher an produktiv, desto mehr
Punkte lohnen ein echtes Gespräch. Ein Anhaltspunkt: Wenn du bei einem kleinen Werkzeug mehr
als zehn Minuten fragst, fragst du zu viel.

---

## 1. Wie weit soll das gehen?

| Punkt | Wie |
|---|---|
| POC, MVP oder produktiv | **Fragen** — steht vor allem anderen |
| Bis wann wird es gebraucht | **Fragen**, wenn ein Termin im Raum steht (Messe, Jahresabschluss) |
| Wer betreibt das in zwei Jahren | **Fragen** ab MVP. Bei selbstgebauter Software die am häufigsten übersehene Frage — wenn niemand benannt werden kann, ist das ein Ergebnis und gehört in den Plan. |
| Wem gehören Konten und Domain | **Fragen** ab MVP: Firma oder Privatperson? Bei Personalwechsel entscheidet das, ob das Projekt überlebt. |
| Was passiert, wenn ihr es später ablösen wollt | **Selbst entscheiden**: Daten müssen exportierbar bleiben, immer. |
| Budget | **Selbst entscheiden** — nenn die laufenden Kosten im Plan, statt danach zu fragen. |

## 2. Was soll es können, und wer benutzt es?

| Punkt | Wie |
|---|---|
| Der häufigste Ablauf | **Fragen** — das ist die erste Version |
| Was ausdrücklich nicht hineinkommt | **Fragen** und im Plan festhalten. Schützt vor dem Ausufern und ist so wichtig wie die Ja-Liste. |
| Wie es heute läuft und was daran nervt | **Fragen**, besonders wenn nur ein Problem geschildert wurde |
| Wie viele Nutzer, heute und in einem Jahr | **Fragen** grob: zehn, hundert oder tausend? Nur die Größenordnung zählt. |
| Gibt es Bestandsdaten, die mit müssen | **Fragen** — Migration ist oft der aufwendigste Teil und wird fast nie eingeplant |
| Wer bringt es den Leuten bei | **Fragen** ab MVP. Fertige Werkzeuge scheitern häufiger an Nichtbenutzung als an Fehlern. |
| Website, mobil bedienbar, Dashboard oder nur Schnittstelle | **Selbst entscheiden** aus dem Ablauf |
| Braucht es überhaupt ein eigenes Backend | **Selbst entscheiden** |

## 3. Wer darf rein?

| Punkt | Wie |
|---|---|
| Nur du, ein Team oder das Internet | **Fragen** |
| Welche Rollen gibt es | **Fragen**, sobald mehr als eine Sorte Nutzer da ist — fachlich ("Wer darf einen Auftrag stornieren?"), nicht technisch |
| Darf Person A den Datensatz von Person B sehen, ändern, löschen | **Fragen** bei allem, was mehr als eine Abteilung berührt. Das ist der Unterschied zwischen "eingeloggt" und "berechtigt" — und der häufigste Fehler in KI-gebauter Software. |
| Wie angemeldet wird (Mail, Microsoft, Google) | **Selbst entscheiden**, außer es gibt ein Firmen-Anmeldesystem — dann nimm das |
| Wo die Prüfung stattfindet | **Selbst entscheiden**: immer serverseitig, nie nur in der Oberfläche |
| Bremse gegen Passwortraten | **Selbst entscheiden** |

## 4. Welche Daten landen darin?

| Punkt | Wie |
|---|---|
| Was genau gespeichert wird | **Fragen** — und was davon wirklich gebraucht wird. Jedes Feld, das man nicht hat, kann nicht verloren gehen. |
| Was wäre schlimm, wenn es öffentlich wäre | **Fragen** — die eine Frage, aus der Verschlüsselung, Zugriffsregeln, Backups und Löschfunktion folgen |
| Personenbezogen? | **Fragen**, aber als Baufrage: Namen, Adressen, Personalnummern? Wenn ja, werden Lösch- und Exportfunktion gebaut — ohne Diskussion. |
| Wie lange müssen die Daten aufgehoben werden | **Fragen** ab MVP, wenn personenbezogen. Entscheidet, ob es eine automatische Löschung braucht. |
| Werden Dateien hochgeladen | **Fragen** — Bilder, PDFs? Die gehören in einen Dateispeicher, nicht in die Datenbank, und sind bis zum Beweis des Gegenteils fremder Code. |
| Wie die Daten zusammenhängen | **Selbst entscheiden** — aber richtig, das ist eine Einbahnstraße |
| Welche Datenbank | **Selbst entscheiden** |
| Verschlüsselung, Protokollierung von Änderungen | **Selbst entscheiden** nach Risikostufe |

## 5. Läuft das dauerhaft für andere?

| Punkt | Wie |
|---|---|
| Nur dein Rechner oder für andere erreichbar | **Fragen** |
| Vorgaben, wo Daten liegen dürfen | **Fragen** — genau einmal, falls die Erstkonfiguration es nicht schon beantwortet |
| Gibt es eine IT, die mitreden will | **Fragen** ab MVP — lieber jetzt als nach dem Bau |
| Welche anderen Systeme müssen angebunden werden | **Fragen** — Mailpostfach, CRM, Warenwirtschaft, Kalender? Jede Anbindung ist eine Stelle, die ausfallen kann, und gehört in die Schnittstellen-Tabelle des Plans. |
| Was passiert, wenn ein angebundener Dienst ausfällt oder sein Limit erreicht | **Selbst entscheiden**, aber im Plan vermerken |
| Wo es läuft, wie eine neue Version live geht | **Selbst entscheiden** |
| Testumgebung neben der echten | **Selbst entscheiden** — ab produktiv ja, beim POC nein |
| Fehlerbenachrichtigung und Protokolle | **Selbst entscheiden**; beim POC bewusst weglassen und ins `TODO.md` |
| Laufende Kosten, Ausgabenlimits bei KI | **Selbst entscheiden** und im Plan nennen. Limit setzen, bevor der erste Schlüssel benutzt wird. |
| Tests | **Selbst entscheiden**: für den wichtigsten Ablauf ab MVP, beim POC nicht |
| Versionsverwaltung | **Selbst entscheiden**: immer, ab der ersten Zeile |

## 6. Was passiert, wenn es kaputt ist?

| Punkt | Wie |
|---|---|
| Was steht still, wer merkt es | **Fragen** — bestimmt, wie viel Absicherung sich lohnt |
| Wen ruft man an, wenn es am Wochenende hängt | **Fragen** ab MVP. Oft gibt es keine Antwort — dann ist das ein Ergebnis für den Plan. |
| Wie lange darf es ausfallen | **Fragen** ab produktiv: eine Stunde, ein Tag, eine Woche? |
| Wie viel Datenverlust wäre verkraftbar | **Fragen** ab produktiv — daraus folgt, wie oft gesichert wird |
| Backups und ob die Rückspielung getestet ist | **Selbst entscheiden**. Ein Backup ist erst dann eines, wenn eine Wiederherstellung einmal funktioniert hat — Datum in den Plan. |
| Zurück auf die vorige Version | **Selbst entscheiden** — deshalb von Anfang an Git |

---

## Zwei Punkte, die kein Standard führt, aber Projekte kippen

**Betriebsrat.** Sobald ein Werkzeug sichtbar macht, wer was wie schnell bearbeitet, greift die
Mitbestimmung (§ 87 Abs. 1 Nr. 6 BetrVG). Das ist keine Formalie: Ohne Zustimmung darf das
Werkzeug nicht eingesetzt werden, egal wie gut es ist. Sprich es früh an, wenn es um ein
Werkzeug für Kolleginnen und Kollegen geht — nicht nach dem Bau.

**Verhältnis zur bestehenden IT.** Ein Werkzeug, das an der IT vorbei entsteht, wird oft
abgeschaltet, sobald es wichtig wird. Frag früh, wer so etwas absegnet, und halt fest, was
vereinbart wurde.

## Wenn E-Mails verschickt werden

Sobald das Werkzeug Benachrichtigungen oder Formularbestätigungen versendet, braucht die
Absenderdomäne SPF, DKIM und DMARC — sonst landet alles im Spam und niemand versteht, warum.
Das ist eine Einstellung beim Domänen-Anbieter, kein Code, und gehört ins `TODO.md` mit dem
Hinweis, dass die IT das macht.
