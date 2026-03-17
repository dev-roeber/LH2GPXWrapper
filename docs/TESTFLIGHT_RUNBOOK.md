# TestFlight + App Store Runbook

Stand: 2026-03-17 | Phase 20

---

## Lokal verifizierter Stand

| Punkt | Status | Nachweis |
|-------|--------|---------|
| `xcodebuild archive` | **verifiziert** | 2026-03-17, v1.0 Build 1, neues Icon korrekt eingebaut |
| Bundle Identifier | `de.roeber.LH2GPXWrapper` | project.pbxproj |
| Marketing Version | `1.0` | project.pbxproj |
| Build Number | `1` | project.pbxproj |
| Display Name | `LH2GPX` | project.pbxproj |
| Deployment Target | iOS 26.2 | project.pbxproj |
| Signing | Automatic, Team `XAGR3K7XDJ` | project.pbxproj |
| PrivacyInfo.xcprivacy | konform (kein Tracking, UserDefaults CA92.1) | PrivacyInfo.xcprivacy |
| App Icon | Map-Pin + "LH2GPX", 1024x1024 | Assets.xcassets/AppIcon.appiconset/ |
| App Review Guidelines | geprueft, konform | Abschnitt unten |

---

## App Store Review Guidelines – Pruefergebnis

Geprueft gegen die relevanten Abschnitte (Stand 2026-03):

| Abschnitt | Befund | Status |
|-----------|--------|--------|
| 2.1 App Completeness | vollstaendiger Location-History-Viewer, Demo-Modus vorhanden | ✅ |
| 2.3.12 Placeholder Content | App Icon: Map-Pin + App-Name (kein Gradient-Placeholder mehr) | ✅ |
| 4.2 Minimum Functionality | NavigationSplitView, Day-Detail, Map, Import, Demo | ✅ |
| 5.1.1 Data Collection | keine Daten gesammelt, kein Netzwerk, kein Tracking | ✅ |
| 5.1.2 Privacy Manifests | PrivacyInfo.xcprivacy vorhanden, UserDefaults CA92.1 | ✅ |
| 5.1.5 Location | keine CoreLocation / GPS-Nutzung, nur Import-Visualisierung | ✅ |

Kein bekannter Review-Blocker.

---

## Trennung: lokal lösbar / extern / nachgelagert

### Lokal – erledigt

- [x] App Icon (kein Placeholder mehr, 2026-03-17)
- [x] `xcodebuild archive` verifiziert
- [x] Privacy / Compliance geprueft
- [x] App Review Guidelines geprueft

### Lokal – noch offen (manuell, kein ASC nötig)

- [ ] Screenshots erstellen (Simulator-Workflow unten dokumentiert)

### Extern – erfordern App Store Connect / Apple-Zugang

- [ ] App Store Connect Projekt anlegen (einmalig)
- [ ] App-Metadaten in ASC eintragen (Beschreibung, Keywords, Kategorie, URLs)
- [ ] Screenshots in ASC hochladen
- [ ] Distribution-Export signieren und hochladen
- [ ] TestFlight-Beta aktivieren (interne Tester)

### Nachgelagert – erst nach laufender Beta relevant

- [ ] Beta-Feedback einarbeiten
- [ ] ggf. Crash-Reports aus TestFlight pruefen

---

## Screenshots – lokaler Simulator-Workflow

Screenshots koennen lokal mit dem iOS-Simulator erstellt werden.
Die App-Interaktion (Demo-Modus) ist manuell erforderlich.

### Erforderliche Geräteklassen (App Store Connect)

| Klasse | Auflosung | Simulator |
|--------|-----------|-----------|
| iPhone 6.9" | 1320 × 2868 | iPhone 17 Pro Max (UDID: `013AF8FF-B334-4855-BFB7-12C3C1FD6B2A`) |
| iPad Pro 13" | 2064 × 2752 | iPad Pro 13-inch M4 (UDID: `342C95A4-7AFF-43AF-A3C0-EB370DF819C9`) |

Mindestens 1 iPhone-Klasse ist Pflicht. iPad-Screenshots sind empfohlen, da die App
TARGETED_DEVICE_FAMILY = 1,2 (iPhone + iPad) hat.

### Schritte

```bash
# 1. Simulator starten
xcrun simctl boot 013AF8FF-B334-4855-BFB7-12C3C1FD6B2A
open -a Simulator

# 2. App fuer Simulator bauen und installieren
xcodebuild build \
  -project LH2GPXWrapper.xcodeproj \
  -scheme LH2GPXWrapper \
  -destination 'platform=iOS Simulator,id=013AF8FF-B334-4855-BFB7-12C3C1FD6B2A' \
  -derivedDataPath /tmp/sim_build

APP=$(find /tmp/sim_build -name "LH2GPXWrapper.app" | head -1)
xcrun simctl install booted "$APP"

# 3. App starten
xcrun simctl launch booted de.roeber.LH2GPXWrapper

# 4. Manuell im Simulator: "Demo Data" laden, Tage auswaehlen, Detail oeffnen
# 5. Screenshots
mkdir -p ~/Desktop/LH2GPX_Screenshots
xcrun simctl io booted screenshot ~/Desktop/LH2GPX_Screenshots/01_dashboard.png
# … (nach jeder relevanten Screen-Navigation)

# Fuer iPad (gleiches Vorgehen mit anderer UDID):
xcrun simctl boot 342C95A4-7AFF-43AF-A3C0-EB370DF819C9
```

### Empfohlene Screenshot-Screens

1. Dashboard / Startansicht (nach Demo-Daten-Load)
2. Day-Liste mit mehreren Eintraegen
3. Day-Detail mit strukturierten Sections
4. Day-Detail mit Karte + Pfad (Map-View)
5. Import-Dialog oder Leer-/Startzustand

---

## Archive-Build (lokal reproduzierbar)

```bash
cd ~/Desktop/Github-ios/LH2GPXWrapper

xcodebuild archive \
  -project LH2GPXWrapper.xcodeproj \
  -scheme LH2GPXWrapper \
  -destination 'generic/platform=iOS' \
  -archivePath ~/Desktop/LH2GPXWrapper.xcarchive
```

Verifiziert 2026-03-17: `** ARCHIVE SUCCEEDED **`, v1.0 Build 1.

---

## Distribution-Export (nach Archive)

ExportOptions.plist anlegen:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store-connect</string>
    <key>teamID</key>
    <string>XAGR3K7XDJ</string>
    <key>uploadSymbols</key>
    <true/>
    <key>uploadBitcode</key>
    <false/>
</dict>
</plist>
```

```bash
xcodebuild -exportArchive \
  -archivePath ~/Desktop/LH2GPXWrapper.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath ~/Desktop/LH2GPXWrapper_export
```

Alternativ: Xcode Organizer → Distribute App → App Store Connect → Upload.

---

## App Store Connect – manuelle Schritte (externer Zugang erforderlich)

### App anlegen (einmalig)
- appstoreconnect.apple.com → Apps → + Neue App
- Plattform: iOS
- Name: LH2GPX
- Bundle ID: `de.roeber.LH2GPXWrapper`
- SKU: z. B. `LH2GPX-001`

### Metadaten
- **Name:** LH2GPX
- **Untertitel** (optional, max. 30 Z.): Location History Viewer
- **Kurzbeschreibung** (max. 170 Z.):\
  Importiere deinen Google-Location-Verlauf und sieh ihn als Tageslisten mit Karte.
- **Beschreibung:**\
  LH2GPX laedt deinen exportierten Google-Location-Verlauf (app_export.json) und
  zeigt ihn als uebersichtliche Tagesliste mit Detail-Ansicht und Karte.
  Besuche, Aktivitaeten und Pfade werden strukturiert dargestellt.
  Alle Daten verbleiben lokal – keine Cloud, kein Tracking, keine Werbung.
- **Keywords:** location history, google takeout, karte, standortverlauf, gpx
- **Kategorie:** Dienstprogramme (Utilities)
- **Support-URL:** (einzutragen)
- **Datenschutzrichtlinien-URL:** (Pflicht – einzutragen)

### TestFlight aktivieren
- App Store Connect → TestFlight → Build waehlen
- Beta App Description: "Erster interner Beta-Build von LH2GPX"
- Interne Tester (Apple ID) hinzufuegen
- Build freigeben

---

## Fazit Readiness

Lokal ist alles vorbereitet, was ohne ASC-Zugang moeglich ist.
Die verbleibenden Schritte sind klar getrennt und dokumentiert.
Phase 21 (v1.0 Release) beginnt erst nach Beta-Abschluss und Feedback-Einarbeitung.
