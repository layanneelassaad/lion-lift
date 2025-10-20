# Lion Lift: Airport Carpool Matching for Columbia Students (iOS)

**Lion Lift** helps students share rides to/from NYC airports: enter your flight, get matched with peers on similar schedules, chat, and split the cost.

## Features
- **Flight-aware matching** (windowed by airport/time)
- **In-app chat** to coordinate pickup/drop-off
- **Campus-only access** (verification via Auth provider)
- **MapKit flows** for locations
- **Extensible** for delays, weather, and loyalty later

## Tech Stack
- **Swift / SwiftUI**, iOS 16+
- **Firebase** (Auth + Firestore/RTDB) for identity & data
- **MapKit** for maps/locations
- (Optional) server-side integrations (flight/weather APIs, LLM assist)

## Requirements
- macOS with **Xcode 15+**
- Apple Developer account (code signing)
- A Firebase project (download `GoogleService-Info.plist`)

## Setup
1. **Clone & open**
   ```bash
   git clone <your repo ssh/https>
   cd lion-lift
   open "Lion Lift.xcodeproj"
   ```
2. Firebase:
- Create a Firebase iOS app whose Bundle ID matches the Xcode target.
- Download GoogleService-Info.plist and add it to the app target (copy if needed).
- Enable your chosen Auth providers (e.g., Email/Password, Sign in with Apple).
- Create Firestore (or RTDB) and set permissive rules for dev; lock down for prod.

3. Dependencies (SPM)
  - Xcode → File → Add Packages… → https://github.com/firebase/firebase-ios-sdk
  - Add Auth and Firestore (or Database) as needed.
 
 4. Build & Run
  - Select a simulator/device → Run.
  - On first launch: sign in → add flight → get matches → chat & coordinate.
