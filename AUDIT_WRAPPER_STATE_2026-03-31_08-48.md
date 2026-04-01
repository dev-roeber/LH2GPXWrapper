# AUDIT Wrapper State (LH2GPXWrapper) - 2026-03-31_08-48

## 1. Ziel / Scope

Repo-wahre Statusdokumentation fuer das Wrapper-Repo im 4-Repo-System. Kein Code- oder Build-Eingriff, nur Doku.

## 2. Gelesene Pflichtdateien

README.md, CHANGELOG.md, ROADMAP.md, NEXT_STEPS.md, docs/LOCAL_IPHONE_RUNBOOK.md, docs/TESTFLIGHT_RUNBOOK.md, AUDIT_4REPO_WRAPPER_2026-03-31_08-16.md

## 3. Frisch auf diesem Linux-Host verifiziert

- `git status --short --branch` vor Aenderungen sauber
- `xcodebuild` auf diesem Host nicht vorhanden
- eingebundener Core-Stand frisch Linux-seitig bestaetigt: `swift test` im Repo `LocationHistory2GPX-iOS` -> 228 Tests, 2 Skips, 0 Failures

## 4. Repo-Rolle

- Apple-/Packaging-/Runbook-Bruecke fuer die eigentliche iOS-App
- Xcode-/iPhone-/Simulator-/TestFlight-/App-Store-nahe Schicht
- nicht die fachliche Truth-Quelle fuer Parsing, Datenlogik oder GPX-Export

## 5. Historisch belegt, aber nicht frisch auf diesem Host verifiziert

- fruehere `xcodebuild`-Laeufe
- fruehere Simulator-Laeufe
- fruehere Device-/iPhone-Befunde

## 6. Offene Punkte

- frischer Apple-CLI-Gegenlauf auf Apple-Host
- frische Device-Verifikation fuer Live, Upload, Heatmap, Background-Recording und Auto-Restore
- Privacy-Manifest-/Upload-Scope offen
- vorbelegte Testserver-Defaults duerfen nicht Produktstandard bleiben

## 7. Konkrete Doku-Korrekturen dieses Laufs

1. README nennt die Linux-Grenze jetzt expliziter
2. README markiert den vorbelegten Testendpunkt als offenen Produktpunkt statt als stillen Normalzustand
3. `NEXT_STEPS.md` fuehrt die Bereinigung der Testserver-Defaults expliziter

## 8. Ehrliche Grenzen

- auf diesem Linux-Host keine frische `xcodebuild`-, Simulator- oder Device-Pruefung moeglich
- der Wrapper-Stand ist damit nur hostbedingt begrenzt frisch verifiziert

## 9. Abschlussfazit

Das Wrapper-Repo ist dokumentiert und weiter stimmig, bleibt aber fuer den echten Produktnachweis auf Apple-Umgebung angewiesen. Die wichtigste offene Doku-Korrektur in diesem Lauf war die klare Markierung der Testserver-Defaults als Nicht-Produktstandard.
