# Wenn der Rechner der Firma gehört

Lies das, sobald der Umgebungs-Scan fehlende Adminrechte, einen Proxy oder nicht erreichbare
Dienste meldet. In einem größeren Mittelständler oder Konzern ist das der Regelfall, nicht die
Ausnahme — und der Unterschied zum privaten Laptop ist groß genug, um ein Projekt zu kippen,
wenn man ihn zu spät merkt.

Der häufigste Fehler an dieser Stelle: munter mit dem Einrichten anfangen, an einem
Zertifikatsfehler hängenbleiben und zwei Stunden später feststellen, dass die IT ohnehin nichts
davon erlaubt hätte. **Klär die Rahmenbedingungen, bevor du etwas installierst.**

## Die vier Hürden — und was sie bedeuten

### Keine Adminrechte

Sehr häufig. Heißt nicht, dass nichts geht: Vieles lässt sich im eigenen Benutzerordner
installieren, ohne Adminrechte.

- **Node** über `fnm` oder `nvm` — installiert nach `~/.local` bzw. `~/.nvm`.
- **Python** ist auf macOS und Linux fast immer schon da; `uv` installiert sich im Benutzerordner.
- **Git** ist auf macOS über die Entwicklerwerkzeuge meist vorhanden (`xcode-select --install`
  fragt nach Adminrechten — auf Firmenrechnern oft trotzdem erlaubt, einfach versuchen).

Wenn nicht einmal der Benutzerordner beschreibbar ist, ist die Maschine hart abgeriegelt. Dann
führt kein Weg an der IT vorbei.

### Proxy und Zertifikate

Die tückischste Hürde, weil die Fehlermeldungen nicht nach "Proxy" aussehen, sondern nach
kaputtem Internet. Viele Firmen brechen TLS auf und schieben ein eigenes Zertifikat unter —
`npm install` und `git clone` scheitern dann mit Zertifikatsfehlern.

```bash
# Proxy bekanntmachen
npm config set proxy "$HTTP_PROXY"
npm config set https-proxy "$HTTPS_PROXY"
git config --global http.proxy "$HTTPS_PROXY"

# Firmenzertifikat einbinden (Pfad von der IT erfragen)
export NODE_EXTRA_CA_CERTS=/pfad/zum/firmen-ca.pem
npm config set cafile /pfad/zum/firmen-ca.pem
```

Was du **nicht** tust: `NODE_TLS_REJECT_UNAUTHORIZED=0` oder `strict-ssl false`. Das schaltet
die Prüfung ab, statt sie richtig einzurichten — und es steht später in der Anleitung, die
jemand anders kopiert. Frag lieber nach dem Zertifikat.

### Gesperrte Quellen

Viele Firmen sperren npm und PyPI und stellen stattdessen einen internen Spiegel bereit
(Artifactory, Nexus). Der Scan zeigt das als "NICHT ERREICHBAR".

```bash
npm config set registry https://artifactory.firma.de/api/npm/npm-remote/
pip config set global.index-url https://artifactory.firma.de/api/pypi/pypi/simple
```

Die Adresse weiß die IT. Das ist eine kleine, konkrete Frage, die fast immer schnell beantwortet
wird — anders als "darf ich Software installieren".

### Cloud gesperrt oder Daten dürfen nicht raus

Die einschneidendste Hürde, weil sie den ganzen Stack umwirft. Wenn Supabase und Vercel nicht
erreichbar sind oder Firmendaten das Haus nicht verlassen dürfen, fällt die Standardwahl weg.

| Lage | Realistischer Weg |
|---|---|
| Microsoft-Haus | Azure, Entra ID für den Login, ggf. Power Platform. Umständlicher, geht aber durch die Freigabe. |
| Eigene Server vorhanden | Postgres und die Anwendung in Docker auf einem internen Server. Braucht jemanden, der ihn betreibt — das musst du ansprechen. |
| Gar nichts geht nach außen | Ein rein lokales Werkzeug (Python + Streamlit), das nur auf dem Rechner läuft. Keine Anmeldung, keine gemeinsame Datenbank — dafür sofort startklar. |

Sag ehrlich, was das kostet: *"Wenn die Daten das Haus nicht verlassen dürfen, können wir das
nicht bei einem Cloud-Anbieter bauen. Dann läuft es entweder auf einem eurer Server — dafür
brauchen wir jemanden aus der IT — oder ich baue erstmal ein Werkzeug, das nur auf deinem
Rechner läuft. Das geht sofort, aber deine Kollegin kann es dann nicht mitbenutzen."*

## Mit der IT reden — richtig

Die IT ist nicht der Gegner. Sie ist der Grund, warum das Projekt am Ende betrieben werden darf.
Zwei Dinge machen den Unterschied:

**Früh fragen, nicht wenn es klemmt.** Nach dem Auftragsgespräch, bevor eingerichtet wird.

**Konkret fragen statt allgemein.** "Darf ich Software installieren?" bekommt ein Nein. Das hier
bekommt oft ein Ja:

> Ich baue ein kleines internes Werkzeug für [Zweck]. Dafür bräuchte ich:
> 1. Node.js — Installation im Benutzerordner, keine Adminrechte nötig
> 2. Die Adresse eures npm-Spiegels und das Firmenzertifikat
> 3. Freigabe für [Dienst], oder alternativ einen Platz auf einem internen Server
>
> Die Daten sind [Art der Daten]. Gibt es Vorgaben, wo die liegen dürfen?

Wenn es eine Schatten-IT-Diskussion gibt, ist das ein gutes Zeichen: Dann wird das Werkzeug
ernst genommen. Halt fest, was vereinbart wurde, und schreib es ins `PLAN.md` — beim nächsten
Personalwechsel weiß es sonst niemand mehr.

## Was du im Blick behältst

- **Claude selbst braucht Netz.** Wenn `api.anthropic.com` im Scan nicht erreichbar ist, geht
  gar nichts — dann ist die Freigabe dafür der allererste Schritt.
- **VPN erklärt merkwürdiges Verhalten.** Manches ist nur im VPN erreichbar, anderes nur außerhalb.
  Wenn Dinge wechselhaft funktionieren, ist fast immer das die Ursache.
- **Windows ohne WSL.** Wenn die Firma WSL sperrt, wird es zäh. Dann eher etwas nehmen, das im
  Browser läuft, oder Python direkt unter Windows.
- **Wem gehören die Accounts?** Auf Firmenrechnern gilt das doppelt: Ein Projekt, das an einer
  privaten GitHub-Adresse hängt, gehört später der Privatperson und nicht der Firma.
