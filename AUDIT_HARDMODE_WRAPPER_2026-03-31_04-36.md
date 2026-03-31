# AUDIT_HARDMODE_WRAPPER_2026-03-31_04-36

## Ziel / Scope

- Vollstaendiger Repo-Truth-Audit des Wrapper-Repos `LH2GPXWrapper`
- Abgleich gegen den eingebundenen Core-Stand, gegen historische Apple-Nachweise und gegen die aktuelle Linux-Audit-Realitaet

## Gelesene Pflichtdateien

- `CHANGELOG.md`
- `README.md`
- `NEXT_STEPS.md`
- `ROADMAP.md`
- `docs/LOCAL_IPHONE_RUNBOOK.md`
- `docs/TESTFLIGHT_RUNBOOK.md`

## Zusaetzlich gepruefte relevante Dateien

- `LH2GPXWrapper.xcodeproj/project.pbxproj`
- `Config/Info.plist`
- `LH2GPXWrapper/PrivacyInfo.xcprivacy`
- `LH2GPXWrapper/ContentView.swift`
- `LH2GPXWrapper/LH2GPXWrapperApp.swift`
- `LH2GPXWrapperTests/LH2GPXWrapperTests.swift`
- `LH2GPXWrapperUITests/LH2GPXWrapperUITests.swift`
- `LH2GPXWrapperUITests/LH2GPXWrapperUITestsLaunchTests.swift`
- `LH2GPXWrapper.xctestplan`

## Ausgefuehrte Pruefungen / Befehle

- `git status --short --branch`
- `git log --oneline -n 5`
- `sed -n ...` auf den Pflichtdokumenten
- `git diff --check`
  - Ergebnis: sauber
- indirekter Core-Gegenlauf:
  - `swift test` im eingebundenen Core-Repo: `228` Tests, `2` Skips, `0` Failures
- `command -v xcodebuild`
  - Ergebnis auf Audit-Host: nicht vorhanden

## Wichtigste Befunde

### 1. Wrapper-Doku hing beim aktuellen Core-Teststand hinterher

- `README.md`, `ROADMAP.md` und `NEXT_STEPS.md` nannten noch `217` Tests als aktuellen Linux-Stand.
- Repo-wahr ist fuer diesen Audit-Zeitpunkt nur der neue Core-Gegenlauf `228 / 2 / 0`.

### 2. Review-/Privacy-Wording war zu stark

- `docs/TESTFLIGHT_RUNBOOK.md` beschrieb `PrivacyInfo.xcprivacy` als `konform`, obwohl lokal nur die Datei und ihr Inhalt belegt sind.
- Dasselbe Dokument sprach trotz offener `5.1.1`-/`5.1.2`-Punkte von keinem unmittelbaren Review-Blocker.
- Beides war fuer den optionalen Upload-Pfad zu stark.

### 3. Historische Apple-Nachweise waren nicht sauber von aktuellem Audit getrennt

- Runbooks und README nutzten den `2026-03-30`-Stand teils wie einen aktuellen Gegenlauf.
- Repo-wahr ist: letzter dokumentierter Apple-/Device-Stand bleibt historisch; in diesem Linux-Audit wurde kein neues `xcodebuild` gefahren.

### 4. Wrapper-Planungsdokumente unterschlugen sichtbare Core-Features

- `ROADMAP.md` und `NEXT_STEPS.md` waren bei `Days`-Default-Sortierung, segmentierten Insights und ausgebautem Upload-/Live-UI-Status nicht mehr voll synchron zum real im Wrapper sichtbaren Core-Stand.

## Konkrete Korrekturen

- `CHANGELOG.md`
  - neuen Audit-/Truth-Sync-Eintrag fuer `2026-03-31` hinzugefuegt
- `README.md`
  - aktuellen Core-Linux-Teststand auf `228 / 2 / 0` aktualisiert
  - fehlenden frischen Apple-Gegenlauf auf diesem Host klar dokumentiert
- `ROADMAP.md`
  - Kopfblock auf `2026-03-31` synchronisiert
  - Live-/Upload-/Insights-/Days-Scope repo-wahr nachgezogen
  - Linux-/Apple-Teststatus und Verifikationsgrenzen korrigiert
- `NEXT_STEPS.md`
  - aktuellen Linux-Mindestnachweis aktualisiert
  - Phase 19.51 um `Live` / `Insights` / `Days` auf Apple erweitert
  - Phase 19.52 auf echten offenen Apple-Host-Gegenlauf fuer den aktuellen Stand zugeschnitten
- `docs/LOCAL_IPHONE_RUNBOOK.md`
  - historischen Device-Befund als historischen Befund markiert
  - fehlenden frischen Apple-Gegenlauf auf aktuellem Audit-Host nachgetragen
- `docs/TESTFLIGHT_RUNBOOK.md`
  - `PrivacyInfo.xcprivacy` nur noch als lokal sichtbarer Konfigurationsstand beschrieben
  - zu starkes Review-Blocker-Wording entfernt

## Verbleibende offene Punkte

- frischer Wrapper-`xcodebuild`-Build/Test auf Apple-Host
- frischer Device-Durchlauf fuer Heatmap, Live, Insights, Days, Background-Recording, Upload
- belastbare Apple-Review-/Privacy-Einordnung fuer den optionalen Upload
- breitere Wrapper-Testabdeckung fuer Restore-/Upload-Pfade

## Ehrliche Grenzen der Verifikation

- dieses Audit lief auf Linux ohne `xcodebuild`
- deshalb wurden keine neuen Apple-, Simulator- oder Device-Aussagen erzeugt
- historische Audit-Dateien und historische Apple-Nachweise bleiben als Historie erhalten

## Abschlussfazit

Die Wrapper-Doku ist wieder auf denselben Wahrheitsstandard wie der Core gezogen: aktueller Linux-Stand ist frisch, Apple-Nachweise bleiben historisch, und der offene Review-/Privacy-Status des optionalen Uploads wird nicht mehr weichgezeichnet.
