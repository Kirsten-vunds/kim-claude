# Stack-Entscheidung

Entscheide selbst und begründe kurz. Die Person kann die Optionen nicht bewerten — eine
Auswahlfrage überfordert nur und verzögert.

Zwei Kriterien, in dieser Reihenfolge:

1. **Was passt zur Sache?**
2. **Was kann diese Person in einem halben Jahr noch selbst betreiben?** Ein Stack, der eine
   Kommandozeile und Docker braucht, bleibt beim ersten Update stehen. Im Zweifel das, was sich
   über eine Webseite bedienen lässt — auch wenn es technisch weniger elegant ist.

## Standardwahl nach Art des Vorhabens

| Was gebaut wird | Nimm | Warum |
|---|---|---|
| Auswertung, Übersicht, Dashboard für eine Person | Python + Streamlit, lokal | Läuft in Minuten, kein Hosting, kein Account |
| Internes Werkzeug für ein Team | Next.js + Supabase + Vercel | Login, Datenbank, Rechte schon eingebaut; online in Minuten |
| Öffentliche Seite mit Anmeldung | Next.js + Supabase + Vercel | Dieselbe Kette, nur mit strengeren Regeln |
| Nur eine Schnittstelle, kein Bildschirm | FastAPI + Postgres, Railway oder Render | Wenig Aufbau, klare Struktur |
| Automatisierung zwischen Systemen | Kein eigener Code — n8n | Wenn es Kästchen-und-Pfeile ist, bau keine Software |
| Mobile App | Erst als Webseite bauen, mobil bedienbar | App-Stores bedeuten Entwicklerkonten, Freigabeverfahren, Update-Zyklen. Fast nie den Aufwand wert. |

## Warum diese Voreinstellung

**Supabase** ist Postgres mit fertigem Login, Rechteverwaltung und Dateiablage. Für Laien der
größte Hebel: Was sonst zwei Wochen Eigenbau wäre, ist angeklickt. Region Frankfurt wählen.
Achtung — Zeilenschutz (RLS) ist bei neuen Tabellen nicht automatisch an, siehe `bauregeln.md`.

**Vercel** stellt online, sobald etwas in GitHub landet. Kein Server, keine Zertifikate. Für
kleine Projekte kostenlos.

**Postgres statt einer Datei-Datenbank**, sobald mehr als eine Person schreibt. SQLite ist
großartig für ein Werkzeug auf einem Rechner und schmerzhaft, sobald zwei Leute gleichzeitig
arbeiten.

**Fertige Bausteine vor Eigenbau.** Login, Zahlungen, Mailversand, Dateiablage: nichts davon
selbst schreiben. Das ist keine Bequemlichkeit — es sind genau die Stellen, an denen selbst
gebaute Lösungen Sicherheitslücken haben.

## Wenn es Vorgaben gibt

Wenn eine IT-Abteilung existiert oder Daten das Haus nicht verlassen dürfen, ändert das alles.
Frag das einmal ab (Schritt 5 im Skill) und weich dann ab:

- **Daten müssen im Haus bleiben** → Postgres auf einem eigenen Server, Docker. Braucht jemanden,
  der ihn betreibt — das musst du dann ansprechen, nicht wegmoderieren.
- **Microsoft-Haus** → Azure statt Vercel, Entra ID für den Login. Umständlicher, aber es geht
  durch die Freigabe.
- **Es gibt schon Vorgaben** → nimm sie. Ein technisch besserer Stack, den die IT ablehnt, ist
  kein besserer Stack.

## Was du nie zur Wahl stellst

Programmiersprache, Framework, Datenbank-Produkt, Hosting-Anbieter, Testverfahren,
Deployment-Weg. Entscheide, sag es in einem Satz, gib ein Veto. Die einzige Stack-Frage, die
du stellst: ob es im Unternehmen Vorgaben gibt, wo Daten liegen dürfen.
