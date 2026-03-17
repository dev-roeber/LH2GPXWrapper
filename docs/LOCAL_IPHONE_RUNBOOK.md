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

| Geraet | iOS-Version | Deploy | Demo | Import (app_export.json) | Import (location-history.json) | Persistenz | Karte |
|--------|-------------|--------|------|--------------------------|-------------------------------|-----------|-------|
| iPhone 17 Pro Max | 26.3 (Simulator) | ✅ (Build) | ✅ | ✅ | klare Fehlermeldung ✅ | offen | ✅ |
| iPhone 15 Pro Max | iOS 26.2 | ✅ Deploy | ✅ Demo | ✅ | klare Fehlermeldung ✅ | offen | ✅ |
| iPhone 12 Pro Max | iOS 26.2 | ✅ Deploy | ✅ Demo | ✅ | klare Fehlermeldung ✅ | offen | ✅ |

**Realer iPhone-Befund (2026-03-17):**
- App laeuft auf iPhone 15 Pro Max und iPhone 12 Pro Max
- Demo-Daten, Kartenansicht, Day-Detail, Scrollen funktionieren
- Import von `03_03_2026_location-history.json` schlug fehl → Ursache: Google-Takeout-Format (Array-Root), nicht app_export.json
- Nach Fix: Klare Fehlermeldung statt generischem Decode-Fehler

**Unterstuetztes Import-Format:**
- ✅ `app_export.json` – erzeugt von [LocationHistory2GPX](https://github.com/dev-roeber/LocationHistory2GPX) Python-Tool
- ❌ `location-history.json` – roher Google Takeout Export (Array-Root, camelCase): wird klar abgelehnt

**Noch offen:**

Persistenz / Restore ist noch nicht auf echtem Geraet verifiziert:

5. App schliessen, neu starten → zuletzt importierte Datei wiederhergestellt?

Alle anderen Flows sind verifiziert (2026-03-17):
- [x] Build + Install per Xcode
- [x] App starten → Import-Zustand sichtbar
- [x] Demo-Daten laden → Day-Liste sichtbar
- [x] Ersten Eintrag tippen → Day-Detail + Karte
- [x] location-history.json (Google-Format) importieren → klare Fehlermeldung erscheint
- [x] Import-State anzeigen → leerer Zustand sauber
- [ ] App schliessen, neu starten → zuletzt importierte Datei wiederhergestellt

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
