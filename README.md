# LH2GPXWrapper

Xcode-Wrapper-Projekt fuer die iOS-App von LocationHistory2GPX.

## Rolle dieses Repos

- Xcode-Projekt (.xcodeproj) fuer die fertige iOS-App
- bindet das Core-/Consumer-Repo `LocationHistory2GPX-iOS` als lokales Swift Package ein
- liefert Bundle-Metadaten, App-Icon, Privacy-Manifest und Signing-Konfiguration
- ist der Weg zu Geraetedeploy, TestFlight und App Store

## Zwei-Repo-Architektur

| Aspekt | Core-Repo (`LocationHistory2GPX-iOS`) | Wrapper-Repo (`LH2GPXWrapper`) |
|--------|----------------------------------------|-------------------------------|
| Pfad | `~/Code/LocationHistory2GPX-iOS` | `~/Desktop/Github-ios/LH2GPXWrapper` |
| Inhalt | Swift Package: Decoder, Queries, AppSupport, DemoSupport | Xcode-Projekt: App-Target, Bundle-Config, Assets |
| Build | `swift build` / `swift test` | `xcodebuild` / Xcode IDE |
| Tests | Unit-Tests via SwiftPM | Xcode-Unit- und UI-Tests |
| Abhaengigkeit | keins (eigenstaendig) | haengt vom Core-Repo ab (lokale SPM-Referenz) |

## SPM-Abhaengigkeit

Das Xcode-Projekt referenziert das Core-Repo als lokales Swift Package:

```
../../../Code/LocationHistory2GPX-iOS
```

Genutzte Produkte:
- `LocationHistoryConsumerAppSupport` – Produkt-UI (NavigationSplitView, Dashboard, Day-Detail, Map), Session, Loader, Bookmark-Persistenz, Live-Recording-Domain
- `LocationHistoryConsumerDemoSupport` – Demo-Fixture-Loader

## Bundle-Konfiguration

- **Bundle Identifier:** `de.roeber.LH2GPXWrapper`
- **Display Name:** LH2GPX
- **Version:** 1.0 (Build 1)
- **Deployment Target:** iOS 26.2
- **Signing:** Automatic (Team XAGR3K7XDJ)
- **App Icon:** Map-Pin + "LH2GPX", 1024x1024 (Interims-Design, kein Gradient-Placeholder mehr)
- **Privacy Manifest:** `PrivacyInfo.xcprivacy` – kein Tracking, keine Datenerhebung, UserDefaults-Zugriff deklariert; lokale Live-Location ueber Info.plist-Usage-Strings fuer While-In-Use plus optionale `Always Allow`-Erweiterung

## Lokaler Build

In Xcode:
1. `LH2GPXWrapper.xcodeproj` oeffnen
2. Scheme `LH2GPXWrapper` waehlen
3. Zielgeraet oder Simulator waehlen
4. Product > Run

Per CLI:
```bash
xcodebuild -project LH2GPXWrapper.xcodeproj \
  -scheme LH2GPXWrapper \
  -destination 'generic/platform=iOS' \
  build
```

## Produkt-UI (Phase 17–20)

Die App nutzt die Produkt-UI aus dem Core-Repo (`LocationHistoryConsumerAppSupport`):
- NavigationSplitView mit Day-Liste und Detail-Pane
- Overview-Dashboard mit Statistik-Grid
- Day-Detail mit strukturierten Sections und Cards
- Karten-MVP: MapKit-Ansicht im Day-Detail mit Pfad-Polylines und Visit-Markern
- Live-Recording-Sektion im Day-Detail: manueller Toggle, aktueller Standort, Live-Polyline, gespeicherte Live-Tracks
- Optionen-Seite ueber das Actions-Menue: lokale Distanz-Einheit, Start-Tab, Kartenstil und technische Importdetails
- VoiceOver-Accessibility: semantische Labels und Gruppierung fuer alle Kernelemente
- Toolbar-Aktionen mit SF-Symbol-Icons, inklusive Optionen-Seite
- Konsistente Leer-/Fehler-/Ladezustaende
- Edge-Case-Hardening: defensive Guards, robuste Formatierung

## Lokaler iPhone-Betrieb

Verifiziert (2026-03-17):
- `xcodebuild build` erfolgreich (generic/platform=iOS)
- iPhone 15 Pro Max + iPhone 12 Pro Max: Deploy, Demo, Karte, Day-Detail, Scrollen
- Import `app_export.json`: funktioniert
- Persistenz / Restore nach App-Neustart: verifiziert (iPhone 15 Pro Max + iPhone 12 Pro Max, 2026-03-17) – aktuell bewusst deaktiviert (Phase 19.5): App startet immer manuell

Neu auf Code-Stand 2026-03-18:
- Google-Takeout-`location-history.json` und `.zip` werden direkt unterstuetzt
- Live-Location / Live-Recording ist eingebaut (lokal, manuell gestartet; optionaler Background-Modus im aktuellen Code)
- Live-Tracks werden getrennt von importierter History gespeichert; kein Auto-Resume nach Neustart
- Wrapper-Unit-Tests und generischer iOS-Build sind gruen; die komplette UI-Test-Suite lief auf diesem Rechner in einen Simulator-Launcher-Fehler (`Mach error -308`)

Neu auf Code-Stand 2026-03-19:
- eine echte lokale Optionen-Seite ist eingebaut
- Einstellungen wirken app-weit im Wrapper, weil die Preferences-Domain im Core-Repo zentral injiziert wird
- bewusst keine Cloud-, Server- oder Sync-Toggles

Neu auf Code-Stand 2026-03-20:
- der Wrapper deklariert jetzt auch die iOS-Voraussetzungen fuer optionales Background-Live-Recording (`Always Allow`-Usage-String + `location`-Background-Mode)
- der ueber das Core-Repo gelieferte Export-Flow kann jetzt `GPX`, `KML` und `GeoJSON`
- Export unterstuetzt jetzt die Modi `Tracks`, `Waypoints` und `Both`
- lokale Exportfilter decken jetzt auch Bounding Box und Polygon fuer importierte History ab
- frische Device-Verifikation fuer den erweiterten Permission-/Background-Flow ist weiter offen

Unterstuetztes Import-Format: jede `.json`-Datei oder `.zip`-Datei, die einen gueltigen LH2GPX-App-Export enthaelt, plus Google-Timeline-`location-history.json` / `.zip` aus Google Takeout.

Vollstaendiges Device-Runbook: `docs/LOCAL_IPHONE_RUNBOOK.md`

iPad: bewusst spaeter.

## TestFlight + App Store Readiness (Phase 20 – extern geparkt)

Lokal verifiziert (2026-03-17):
- `xcodebuild archive` erfolgreich (v1.0, Build 1)
- `PrivacyInfo.xcprivacy` konform (kein Tracking, UserDefaults CA92.1)
- App Review Guidelines geprueft: konform

Lokal abgeschlossen (2026-03-17):
- App Icon: Map-Pin + "LH2GPX" (kein Gradient-Placeholder mehr)
- Screenshots erstellt: `docs/appstore-screenshots/` (iPhone 17 Pro Max, iPad Pro 13")

Bewusst geparkt (ASC-Zugang erforderlich):
- App Store Connect Projekt anlegen
- Screenshots in ASC hochladen
- Upload / TestFlight-Beta

Vollstaendiger Submission-Leitfaden: `docs/TESTFLIGHT_RUNBOOK.md`

## Was bewusst noch nicht vorbereitet ist

- kein finales App-Icon-Design (Interims-Icon vorhanden, finales Branding-Design steht aus)
- keine Lokalisierung
- keine Heatmap, kein Replay, keine Offline-Karten (ggf. spaetere Phase)
- kein CSV-/KMZ-Export, kein Server-/Sync-Flow
- kein Resume laufender Live-Tracks, kein Server-/Sync-Flow, keine frische Device-Verifikation fuer optionales Background-Live-Recording

## Roadmap

Die vollstaendige Delivery-Roadmap liegt jetzt identisch in beiden Repos:
- [ROADMAP.md](/home/sebastian/repos/LH2GPXWrapper/ROADMAP.md)
- [NEXT_STEPS.md](/home/sebastian/repos/LH2GPXWrapper/NEXT_STEPS.md)

Diese Dateien muessen zwischen Core-Repo und Wrapper-Repo inhaltlich synchron gehalten werden.
