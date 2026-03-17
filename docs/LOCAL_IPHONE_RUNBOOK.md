# Lokaler iPhone-Betrieb – Runbook

Stand: 2026-03-17

---

## Ziel

Die App lokal auf echten iPhones und im Simulator reproduzierbar starten, testen und verifizieren.
Dieses Runbook ersetzt keine App-Store-Einreichung – es dient dem lokalen Entwicklungs- und Verifikationsbetrieb.

iPad-Betrieb kommt spaeter. Dieser Schritt fokussiert iPhone.

---

## Simulator-Betrieb

### Verfuegbare Simulatoren (Stand 2026-03-17, Xcode iOS 26.x)

iOS 26.x bietet folgende iPhone-Simulatoren:

| Simulator | Verfuegbar |
|-----------|-----------|
| iPhone 17 Pro Max | ja (UDID: F671FA96-892A-4849-AD86-3EE9FF8FEB36) |
| iPhone 17 Pro | ja |
| iPhone 17 | ja |
| iPhone 17e | ja |
| iPhone Air | ja |
| iPhone 16e | ja |
| **iPhone 15 Pro Max** | **nein** (kein iOS-26-Simulatorziel) |
| **iPhone 12 Pro Max** | **nein** (kein iOS-26-Simulatorziel) |

**Hinweis:** Apple stellt fuer iOS 26.x keine Simulatorziele fuer aeltere Modelle bereit.
Verifizierung auf iPhone 12 Pro Max und iPhone 15 Pro Max ist nur auf echtem Geraet moeglich.

### Simulator starten (CLI)

```bash
cd ~/Desktop/Github-ios/LH2GPXWrapper

# Build + Launch im Simulator
xcodebuild -project LH2GPXWrapper.xcodeproj \
  -scheme LH2GPXWrapper \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max,OS=latest' \
  build

# Alternativ: kleinstes verfuegbares Geraet (iPhone 16e)
xcodebuild -project LH2GPXWrapper.xcodeproj \
  -scheme LH2GPXWrapper \
  -destination 'platform=iOS Simulator,name=iPhone 16e,OS=latest' \
  build
```

### Verfuegbare Simulatoren pruefen

```bash
xcrun simctl list devices available | grep -E "iOS 26" -A 30 | grep iPhone
```

### Unit-Tests im Simulator

```bash
xcodebuild test \
  -project LH2GPXWrapper.xcodeproj \
  -scheme LH2GPXWrapper \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max,OS=latest' \
  -only-testing:LH2GPXWrapperTests
```

---

## Simulator-Verifikationsstatus (2026-03-17)

| Flow | Status | Geraet |
|------|--------|--------|
| Build (`xcodebuild build`) | verifiziert | generic/platform=iOS |
| Unit-Tests | verifiziert (2 Tests bestanden) | iPhone 17 Pro Max, iOS 26.3 |
| Demo-Daten | verifiziert (Screenshots 02-04) | iPhone 17 Pro Max, iOS 26.3.1 |
| Import-State | verifiziert (Screenshot 01) | iPhone 17 Pro Max, iOS 26.3.1 |
| Day-Liste | verifiziert | iPhone 17 Pro Max, iOS 26.3.1 |
| Day-Detail + Karte | verifiziert | iPhone 17 Pro Max, iOS 26.3.1 |
| Persistenz / Restore | noch offen (manuell auf Geraet zu pruefen) | – |

---

## Geraete-Deploy (echtes iPhone)

### Voraussetzungen

- Xcode mit aktivem Development-Signing (Team XAGR3K7XDJ)
- iPhone per USB verbunden, Geraet vertraut gesetzt
- Deployment Target: iOS 26.2 – das Geraet muss mindestens iOS 26.2 laufen

### Deploy per Xcode (empfohlen)

1. `LH2GPXWrapper.xcodeproj` in Xcode oeffnen
2. Scheme `LH2GPXWrapper` waehlen
3. Zielgeraet (iPhone 15 Pro Max oder iPhone 12 Pro Max) auswaehlen
4. Product > Run

### Deploy per CLI

```bash
cd ~/Desktop/Github-ios/LH2GPXWrapper

xcodebuild -project LH2GPXWrapper.xcodeproj \
  -scheme LH2GPXWrapper \
  -destination 'platform=iOS,name=<Geraetename>' \
  build
```

### Geraet-UDIDs pruefen

```bash
xcrun xctrace list devices 2>/dev/null | grep -v "Simulator"
```

---

## Geraete-Verifikationsstatus (Stand 2026-03-17)

| Geraet | iOS-Version | Deploy | Demo | Import | Persistenz | Karte |
|--------|-------------|--------|------|--------|-----------|-------|
| iPhone 17 Pro Max | 26.3 (Simulator) | ✅ (Build) | ✅ | ✅ | offen | ✅ |
| iPhone 15 Pro Max | – | **nicht verifiziert** | – | – | – | – |
| iPhone 12 Pro Max | – | **nicht verifiziert** | – | – | – | – |

**Ausstehend:** Deploy + voller Flow auf iPhone 15 Pro Max und iPhone 12 Pro Max.
Diese Geraete unterstuetzen iOS 26, haben aber keinen Simulator-Aequivalent in Xcode.

Wenn das Geraet verbunden ist, koennen alle Flows manuell durchgefuehrt werden:

1. Build + Install per Xcode
2. App starten → Import-Zustand sichtbar?
3. Demo-Daten laden → Day-Liste sichtbar?
4. Ersten Eintrag tippen → Day-Detail + Karte?
5. App schliessen, neu starten → zuletzt importierte Datei wiederhergestellt?
6. Ungueltiges JSON importieren → Fehlermeldung sichtbar?
7. Import-State anzeigen → leerer Zustand sauber?

Befunde in dieses Runbook als Tabelle nachtragen.

---

## iPad

iPad-Betrieb kommt bewusst spaeter.
Screenshots fuer ASC sind bereits erstellt (`docs/appstore-screenshots/ipad/`).
Produktiver iPad-Run-Fokus: nachgelagert nach iPhone-Verifikation.

---

## Zusammenhang mit anderen Dokumenten

| Dokument | Inhalt |
|----------|--------|
| `docs/TESTFLIGHT_RUNBOOK.md` | App Store Connect / TestFlight (bewusst geparkt bis ASC-Zugang) |
| `docs/appstore-screenshots/` | Screenshots fuer ASC (lokal erstellt, 2026-03-17) |
| Core-Repo `docs/XCODE_RUNBOOK.md` | Xcode-Runbook fuer das Swift Package |
| Core-Repo `docs/APPLE_VERIFICATION_CHECKLIST.md` | Verifikations-Gates |
