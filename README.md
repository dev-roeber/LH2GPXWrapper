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
- **App Icon:** Platzhalter (1024x1024, wird spaeter durch finales Design ersetzt)
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

## Was bewusst noch nicht vorbereitet ist

- kein finales App-Icon-Design (nur Platzhalter)
- kein App Store Connect Setup
- keine TestFlight-Distribution
- keine Lokalisierung
- keine Heatmap, kein Replay, keine Offline-Karten (ggf. spaetere Phase)

## Roadmap

Die vollstaendige Delivery-Roadmap liegt im Core-Repo unter `ROADMAP.md`.
