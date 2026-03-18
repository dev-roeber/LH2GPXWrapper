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
- `LocationHistoryConsumerAppSupport` – Produkt-UI (NavigationSplitView, Dashboard, Day-Detail, Map), Session, Loader, Bookmark-Persistenz
- `LocationHistoryConsumerDemoSupport` – Demo-Fixture-Loader

## Bundle-Konfiguration

- **Bundle Identifier:** `de.roeber.LH2GPXWrapper`
- **Display Name:** LH2GPX
- **Version:** 1.0 (Build 1)
- **Deployment Target:** iOS 26.2
- **Signing:** Automatic (Team XAGR3K7XDJ)
- **App Icon:** Map-Pin + "LH2GPX", 1024x1024 (Interims-Design, kein Gradient-Placeholder mehr)
- **Privacy Manifest:** `PrivacyInfo.xcprivacy` – kein Tracking, keine Datenerhebung, UserDefaults-Zugriff deklariert

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

## Produkt-UI (Phase 17–19)

Die App nutzt die Produkt-UI aus dem Core-Repo (`LocationHistoryConsumerAppSupport`):
- NavigationSplitView mit Day-Liste und Detail-Pane
- Overview-Dashboard mit Statistik-Grid
- Day-Detail mit strukturierten Sections und Cards
- Karten-MVP: MapKit-Ansicht im Day-Detail mit Pfad-Polylines und Visit-Markern
- VoiceOver-Accessibility: semantische Labels und Gruppierung fuer alle Kernelemente
- Toolbar-Aktionen mit SF-Symbol-Icons
- Konsistente Leer-/Fehler-/Ladezustaende
- Edge-Case-Hardening: defensive Guards, robuste Formatierung

## Lokaler iPhone-Betrieb

Verifiziert (2026-03-17):
- `xcodebuild build` erfolgreich (generic/platform=iOS)
- iPhone 15 Pro Max + iPhone 12 Pro Max: Deploy, Demo, Karte, Day-Detail, Scrollen
- Import `app_export.json`: funktioniert
- Import `location-history.json` (Google Takeout): wird klar abgelehnt mit verstaendlicher Fehlermeldung
- Persistenz / Restore nach App-Neustart: verifiziert (iPhone 15 Pro Max + iPhone 12 Pro Max, 2026-03-17) – aktuell bewusst deaktiviert (Phase 19.5): App startet immer manuell

Unterstuetztes Import-Format: nur `app_export.json` (erzeugt von LocationHistory2GPX Python-Tool).
Rohe Google-Takeout-Dateien werden nicht unterstuetzt und erzeugen eine erklaerende Fehlermeldung.

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

## Roadmap

Die vollstaendige Delivery-Roadmap liegt im Core-Repo unter `ROADMAP.md`.
