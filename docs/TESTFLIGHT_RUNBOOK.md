# TestFlight + App Store Runbook

Stand: 2026-03-17 | Phase 20

Dieses Dokument beschreibt den vollstaendigen Weg von einem lokalen Archive-Build
bis zum TestFlight-Upload und App Store Submit.

---

## Lokal verifizierter Stand (Phase 20)

| Punkt | Status | Nachweis |
|-------|--------|---------|
| `xcodebuild archive` | **verifiziert** | 2026-03-17, `1.0 (Build 1)` |
| Bundle Identifier | `de.roeber.LH2GPXWrapper` | project.pbxproj |
| Marketing Version | `1.0` | project.pbxproj |
| Build Number | `1` | project.pbxproj |
| Display Name | `LH2GPX` | project.pbxproj |
| Deployment Target | iOS 26.2 | project.pbxproj |
| Signing | Automatic, Team `XAGR3K7XDJ` | project.pbxproj |
| PrivacyInfo.xcprivacy | vorhanden, konform | PrivacyInfo.xcprivacy |
| App Icon (1024x1024) | vorhanden (Platzhalter) | Assets.xcassets/AppIcon.appiconset/ |
| Privacy Manifest | UserDefaults CA92.1, kein Tracking | PrivacyInfo.xcprivacy |

---

## App Store Review Guidelines – Pruefergebnis

Geprueft gegen die relevanten Abschnitte der App Store Review Guidelines (Stand 2026-03):

**2.1 App Completeness**
- App laedt und zeigt Location-History-Daten aus einem `app_export.json`-Import
- Demo-Modus mit Fixture vorhanden (kein leerer Startzustand)
- Import, Reset, Clear funktionieren
- Ergebnis: konform

**2.3.12 Placeholder Content**
- App Icon ist derzeit ein Platzhalter (einfaches Design)
- Muss vor App Store Submit durch ein finales Icon ersetzt werden
- Ergebnis: **offen** – manuell zu beheben

**4.2 Minimum Functionality**
- App ist ein vollstaendiger Location-History-Viewer mit NavigationSplitView, Day-Detail, Map
- VoiceOver und Dynamic Type unterstuetzt (Phase 19 verifiziert)
- Ergebnis: konform

**5.1.1 Data Collection and Storage**
- Die App sammelt keine Nutzerdaten
- Keine Netzwerkkommunikation
- Kein Tracking, keine Analytics, keine Ads
- Nutzerdaten (JSON-Import) verbleiben ausschliesslich lokal
- Ergebnis: konform

**5.1.2 Privacy Manifests and Signatures**
- `PrivacyInfo.xcprivacy` vorhanden mit korrekter UserDefaults-Deklaration (CA92.1)
- Kein Tracking, keine Third-Party-SDKs
- Ergebnis: konform

**5.1.5 Location**
- Die App visualisiert vom Nutzer importierte Standortdaten (Google Takeout)
- Die App greift NICHT auf CoreLocation oder GPS zu
- Keine `NSLocationWhenInUseUsageDescription` oder aehnliche Keys noetig
- Ergebnis: konform

**Gesamtbewertung:** konform – bis auf Platzhalter-Icon kein bekannter Review-Blocker.

---

## Archive-Build (lokal)

```bash
cd ~/Desktop/Github-ios/LH2GPXWrapper

xcodebuild archive \
  -project LH2GPXWrapper.xcodeproj \
  -scheme LH2GPXWrapper \
  -destination 'generic/platform=iOS' \
  -archivePath ~/Desktop/LH2GPXWrapper.xcarchive
```

Verifiziertes Ergebnis 2026-03-17:
- `** ARCHIVE SUCCEEDED **`
- `CFBundleShortVersionString = 1.0`
- `CFBundleVersion = 1`

---

## Export fuer Distribution (lokal, nach Archive)

Fuer App Store / TestFlight Export wird eine `ExportOptions.plist` benoetigt:

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

Dann:

```bash
xcodebuild -exportArchive \
  -archivePath ~/Desktop/LH2GPXWrapper.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath ~/Desktop/LH2GPXWrapper_export
```

Alternativ: Archive in Xcode Organizer oeffnen → Distribute App → App Store Connect.

---

## Schritte in App Store Connect (manuell, noch ausstehend)

Diese Schritte koennen nicht lokal automatisiert werden und erfordern Zugang zu
App Store Connect (appstoreconnect.apple.com):

### 1. App anlegen (einmalig)
- App Store Connect → Apps → + Neue App
- Plattform: iOS
- Name: LH2GPX
- Bundle ID: `de.roeber.LH2GPXWrapper`
- SKU: z. B. `LH2GPX-001`
- Benutzerangriff: Alle Benutzer

### 2. App-Metadaten eintragen
- **Name:** LH2GPX
- **Untertitel** (optional, max. 30 Zeichen): z. B. "Location History Viewer"
- **Beschreibung (kurz, max. 170 Zeichen):**
  Importiere deinen Google-Location-Verlauf und sieh ihn als Tageslisten mit Karten.
- **Beschreibung (lang):**
  LH2GPX laedt deinen exportierten Google-Location-Verlauf (app_export.json)
  und zeigt ihn als uebersichtliche Tagesliste mit Detail-Ansicht und Karte.
  Besuche, Aktivitaeten und Pfade werden strukturiert dargestellt.
  Alle Daten verbleiben lokal – keine Cloud, kein Tracking.
- **Keywords:** location history, google takeout, gpx, karte, standortverlauf
- **Kategorie:** Dienstprogramme (Utilities)
- **Support-URL:** (eigene URL eintragen)
- **Datenschutzrichtlinien-URL:** (eigene URL eintragen – Pflicht seit 2019)
- **Marketing-URL** (optional)

### 3. Screenshots bereitstellen
Erforderliche Geraeteklassen (mindestens):
- iPhone 6.7" (iPhone 16 Pro Max): 1320 x 2868 px
- iPad Pro 13" (M4): 2064 x 2752 px

Empfohlen:
- iPhone 6.1" (iPhone 16): 1179 x 2556 px

Inhalt der Screenshots:
- Startansicht / Dashboard
- Day-Liste mit mehreren Eintraegen
- Day-Detail mit Karte und Pfad
- Import-Dialog oder Leerzustand

Erstellen: Simulator in Xcode → gewuenschten Tag laden → Screenshot (Cmd+S).

### 4. Build hochladen
Option A: Xcode Organizer
- Xcode → Product → Archive
- Organizer → Distribute App → App Store Connect → Upload

Option B: CLI
```bash
xcrun altool --upload-app -f LH2GPXWrapper.ipa \
  -t ios --apiKey <KEY> --apiIssuer <ISSUER>
```

### 5. TestFlight aktivieren
- App Store Connect → TestFlight
- Internen Testern hinzufuegen (Apple ID)
- Beta-Beschreibung eintragen: "Erster interner Beta-Build von LH2GPX"
- Build freigeben

### 6. Externer TestFlight-Test (optional vor Submit)
- Beta App Review erforderlich (Apple prueft vor externer Verteilung)
- Externe Tester per E-Mail oder oeffentlichem Link einladen

### 7. App Store Submit
- Alle Metadaten vollstaendig
- Screenshot-Anforderungen erfuellt
- Review-Informationen (Demonutzung: Demo-Modus ohne eigene JSON-Datei verfuegbar)
- "Zur Pruefung einreichen"

---

## Offene Punkte vor erstem TestFlight-Upload

| Punkt | Prio | Notiz |
|-------|------|-------|
| Finales App Icon (1024x1024) | hoch | Platzhalter muss ersetzt werden |
| Datenschutzrichtlinien-URL | hoch | Pflicht fuer App Store Submit |
| Support-URL | mittel | Pflicht fuer App Store Submit |
| App-Beschreibung | mittel | Vorentwurf oben, in ASC eintragen |
| Screenshots (iPhone + iPad) | mittel | Simulator-Screenshots genuegen fuer TestFlight |
| App Store Connect Projekt anlegen | hoch | Einmaliger manueller Schritt |

---

## Grenzen dieser Phase

Phase 20 verifiziert lokal:
- Archive-Build reproduzierbar
- Privacy-Manifest konform
- App Review Guidelines geprueft

Phase 20 verifiziert **nicht** lokal:
- TestFlight-Upload (erfordert ASC-Zugang und fertigen Signing-Export)
- App Store Submit (erfordert vollstaendige Metadaten + Screenshots + ASC)
- Feedback aus Beta (erfordert echte Beta-Tester)

Das ist der Maximalstand, der lokal ohne ASC-Zugang nachweisbar ist.
Phase 21 (v1.0 Release) beginnt erst nach abgeschlossener Beta-Phase.
