# BEAT — Development Notes

[![Disclaimer][disc_img]][disc_url] [![Repo][repo_img]][repo_url]

**License:** GPL-3.0
**Status:** Research Prototype (single iOS target)

---

[disc_img]: https://img.shields.io/badge/disclaimer-privacy-red
[disc_url]: https://github.com/L-anc/BEAT/blob/main/BEAT/Resources/Disclaimer.md

[repo_img]: https://img.shields.io/badge/repo-dev-green
[repo_url]: https://github.com/L-anc/BEAT

## 1. Project Overview

BEAT is an iOS app that collects biometric data from Apple Watch (via HealthKit): heart rate, HRV, active energy, exercise time, body/wrist temperature, respiratory rate, sleep, workouts, blood glucose, and insulin and uploads it to a lab backend. The research goal is **autonomous insulin delivery via glucose prediction** from wearable biometric signals, in support of diabetes research.

---

## 2. Environment & Reproducibility

### Requirements
- Xcode capable of targeting **iOS 26.2**
- A **physical iPhone paired with an Apple Watch (tested on IPhone 13 and Watch 11)**. HealthKit live data and background delivery do not meaningfully exercise on the Simulator, you need real devices to generate real packets.
- Apple Developer account capable of enabling the HealthKit entitlement (`com.apple.developer.healthkit`, `com.apple.developer.healthkit.background-delivery`, see `BEAT.entitlements`).

### Dependencies (Swift Package Manager, pinned in `Package.resolved`)
| Package | Version | Purpose |
|---|---|---|
| MarkdownUI | 2.4.1 | Renders the liability waiver / disclaimer markdown |
| NetworkImage | 6.0.1 | Transitive dependency of MarkdownUI |
| swift-cmark | 0.7.1 | Transitive markdown parser |

`Package.resolved` is committed, so builds are pinned.

### First-time setup
1. Clone the repo and open `BEAT.xcodeproj`.
2. Copy `BEAT/Config.swift.example` → `BEAT/Config.swift` and fill in:
   - `UploadEndpoint`: in `DEBUG`, this points at your Mac's LAN IP (not `localhost`) so a physical device can reach it; in release, it points at the lab server.
   - `UploadAPIKey`: the lab server's key, or `nil` if the server doesn't require one.
   - `Config.swift`: is gitignored on purpose so no server addresses or keys ever enter git history, **do not remove it from `.gitignore`.**
3. **Stand up the backend separately.** `Config.swift.example` references a Docker stack under `server/` (`server/docker-compose.yml`) but `server` is also gitignored, so **that backend code is not in this repository.** Create your own Docker instance and link it to the project before expecting uploads to succeed. Without it, the app still runs and stores data locally; only the sync feature will not run.
4. Build to a physical device, not the simulator, and grant the HealthKit and Local Network permissions when prompted.

### Known reproducibility gaps
- The backend database is not versioned alongside this repo. Anyone picking this up needs to setup their own server code. The project was designed and tested with a MongoDB database in mind. Beware you may run into issues requiring updates to the code between differing database versions and architectures.
- `PRODUCT_BUNDLE_IDENTIFIER = none.BEAT` is a placeholder, you'll need your own bundle ID / provisioning to run on a device.

---

## 3. Data

All data originates from **HealthKit**, read-only (`HKHealthStore`), sourced from whatever the paired Apple Watch has synced to the phone.

**Signal types collected** (each stored as an optional array of `HKDataPoint` inside a packet): heart rate, HRV (SDNN), active energy, exercise time, body temperature, wrist temperature (sleeping), respiratory rate, blood glucose, insulin. Sleep and workout samples are collected via their own point types.

**Units:** every `HKDataPoint` stores its value in a defined SI unit (see `StandardUnits.swift`) plus the HealthKit type identifier, so it can be converted to the user's preferred unit system (metric/imperial, chosen at first launch) on demand. This is why the struct carries `identifier` and `unitString` alongside the raw value rather than just a `Double`.

**Local retention window:** `StorageTime` in `PacketStore.swift` is currently **‑3.2 hours** (`Double(-3.2*3600)`)Packets older than this rolling cutoff are deleted locally via `deleteExpiredPackets()`. Check whether your model/prediction pipeline requires a specific context window and adjust accordingly.

**Upload payload:** `PacketUploader.swift` serializes a `DecodedPacket` plus a stable per-install `deviceId` into `PacketPayload` JSON and POSTs it to `UploadEndpoint` (default path `/api/packets`), intended to land in MongoDB on the lab server.

**No raw data files ship in this repo.** There's no sample dataset, however artificial data packet and demographic samples exist withing the `BEAT/PreviewContent` folder for ease of development in XCode.

---

## 4. Codebase Map

```
BEAT/
├── BEAT.swift                      # @main app entry — builds the SwiftData container,
│                                   # PacketStore, and HealthKitManager; requests HK
│                                   # authorization and starts observing on launch
│
├── RootView.swift                  # Branches on the "firstLaunch" AppStorage flag:
│                                   # WelcomeView (onboarding) vs HomeView (main app)
├── FirstLaunch/
│   ├── WelcomeView.swift           # Intro screen, feature summary
│   │
│   ├── DisclaimerView.swift        # Renders Resources/Disclaimer.md via MarkdownUI;
│   │                               # liability waiver / consent
│   │
│   └── PersonalInfoView.swift      # Collects age, sex, height, weight, unit system
│                                   # → written into Demographics (UserDefaults)
├── AppScreens/
│   ├── HomeView.swift              # Main dashboard
│   │
│   ├── PacketView.swift            # List/browse of packets (via PacketSummary)
│   │
│   └── DetailView.swift            # Full DataPacket detail, deliberately shows the
│                                   # data packet "as is" for transparency
│
├── ComponentViews/                 # Reusable view pieces: GraphView, CardView,
│                                   # SleepPieChartView, DetailRow / SleepDetailRow /
│                                   # WorkoutDetailRow, DataPointListView,
│                                   # WorkoutDataPointListView, FeatureRow
│
├── Models/
│   ├── DataPacket.swift            # @Model DataPacket (SwiftData): one time-windowed
│   │                               # bundle of biometric series, stored as encoded
│   │                               # Data arrays; has PredictedStatus; decoded() 
│   │                               # returns a plain DecodedPacket struct.
│   │                               # PacketSummary: lightweight @Model with a
│   │                               # .cascade delete relationship back to DataPacket
│   │                               # (deleting a packet deletes its summary).
│   │
│   ├── PacketStore.swift           # Query/delete layer over SwiftData: fetch by ID,
│   │                               # last-N, date range, or all-in-window; deletes
│   │                               # expired packets against `StorageTime` cutoff
│   │
│   ├── HKDatapoint.swift           # Codable wrapper around one HKQuantitySample:
│   │                               # timestamp + SI value + HK type identifier +
│   │                               # unit string; can re-derive an HKQuantity or
│   │                               # any preferred unit on demand
│   │
│   ├── StandardUnits.swift         # Defines native backend units per HK identifier
│   │
│   ├── Demographics.swift          # Age/sex/height/weight, persisted as JSON in
│   │                               # UserDefaults
│   │
│   └── AccelDatapoint.swift        # Codable accelerometer sample (x/y/z + magnitude)
│                                   
├── Utilities/
│   ├── HealthKitManager.swift      # Central HK interface: authorization, background
│   │                               # delivery observers, fetch-window bookkeeping,
│   │                               # automatic DataPacket creation/encoding, and
│   │                               # detection of new samples
│   │
│   ├── PacketUploader.swift        # Builds PacketPayload JSON and POSTs to the
│   │                               # backend (endpoint/key from Config.swift)
│   │
│   ├── MotionManager.swift         # Wraps CMSensorRecorder for on-device
│   │                               # accelerometer history, fetch method is
│   │                               # currently commented out (see §6)
│   │
│   ├── ArrayExtensions.swift       # sum/mean helpers over [Double], [HKDataPoint],
│   │                               # plus "preferred unit" sum/mean variants
│   │
│   ├── WorkoutTypeExtensions.swift # HKWorkoutActivityType → display string +
│   │                               # SF Symbol
│   │
│   ├── MarkdownLoader.swift        # Loads a bundled .md resource as a String
│   │
│   └── FileError.swift             # Errors for MarkdownLoader
│
├── PreviewContent/                 # SwiftUI Preview sample data: DataPacketSample,
│                                   # DemographicsSample, WithAppEnvironment helper
│
├── Resources/Disclaimer.md         # The liability waiver text shown at first launch
│
├── Config.swift.example            # Template for the gitignored Config.swift
│
└── Assets.xcassets/                # App icon, accent color, IIT logo (light/dark)
```

**Entry-point trace, if you're new to the code:** `BEATApp.init()` → builds `ModelContainer`/`PacketStore`/`HealthKitManager` → `RootView` → first launch shows `WelcomeView → DisclaimerView → PersonalInfoView`, then flips `firstLaunch` to false → subsequent launches go straight to `HomeView`.

---

## 5. Decision Log

- **AI-assisted front end.** Agentic models (Claude) were used to bootstrap front-end construction and visual design.

- **Project was renamed mid-development.** File header comments still read `InsSense` (e.g. `DataPacket.swift`, `PacketStore.swift`, `HKDatapoint.swift`, `Demographics.swift`) and the HealthKit usage-description string in the Xcode build settings still says *"InsSense reads your health data..."* even though the product is now BEAT. `DisclaimerView.swift` and `MarkdownLoader.swift` headers say `ChatPrototype`, those two files were carried over from an unrelated earlier prototype. None of this affects runtime behavior.

- **Packet / Summary split.** `DataPacket` holds full encoded time series and is relatively expensive to decode; `PacketSummary` holds a handful of native Swift scalars (avg BPM, status, dates) computed at packet creation, so list views don't have to decode full packets just to render a row. The two are linked with a `.cascade` delete rule so a summary can never outlive its packet.

- **Local storage window tuned from 3.0h to 3.2h.** The exact `-3 * 3600` line is commented out in favor of `-3.2*3600` for testing of boundary conditions and redundancy. If the prediction model's context window changes, this constant needs to move with it. Check with whoever owns the model pipeline before changing it in isolation.

- **HKDataPoint stores SI + identifier + unit string, not just a `Double`.** This was a deliberate choice to support per-user metric/imperial display preference without re-querying HealthKit. The identifier is "required for later unit conversions."

- **Detail views show the raw packet "as is."** A stated design goal, for transparency about exactly what's collected. Don't reflexively "simplify" the Detail view without checking whether that transparency guarantee still matters to the research protocol.

- **Use of MongoDB Realm was tested and discarded:** MongoDB Realm SDK for the application's local backend and database API was tested and discarded due to deprecation. It was decided that development would proceed with SwiftData and a local API.

- **Apple Watch → Android/Samsung exploration.** The original notes explain the biggest constraint driving future direction: **Apple Watch only allows raw sensor collection 24 hours after recording**, which is a hard limitation for continuous research collection and insulin administration. After evaluating both medical and consumer-grade options, the the **Samsung Watch 9** is the leading candidate for a parallel/alternate Android path, specifically for its **livestreaming capability** and broader sensor suite.

---

## 6. Known Issues, Limitations & Extension Points

- **Accelerometer capture is stubbed out.** `MotionManager.fetchAccelSamples(from:to:)` (wrapping `CMSensorRecorder`, which itself only buffers ~3 days on-device) is entirely commented out. `AccelDatapoint.swift` exists as a model with no current producer. If accelerometer data is needed, this is the obvious place to pick the work back up, but note `CMSensorRecorder` requires physical-device testing and has its own background-access caveats worth re-reading up on before wiring it in.

- **Backend is not in this repo.** See §2. Anyone extending upload/sync behavior needs the separate `server/` Docker stack, which isn't tracked here. Consider whether that backend should eventually get its own repo with its own notes, or be brought into this one as a submodule.

- **No automated tests.** No `Tests/` target exists in the Xcode project as of this writing. If you're extending this codebase for a thesis or reproducibility purposes, adding coverage for `PacketStore`'s query/cascade-delete logic and `HKDataPoint`'s unit-conversion logic would be the highest-value starting points, since both encode research-relevant correctness assumptions.

- **Extension point, new signal types:** the `DataPacket` / `HKDataPoint` / `PacketStore` pattern is designed to generalize. Adding a new HealthKit signal means: add a case to `StandardUnits.swift`'s SI/imperial tables, add a field to `DataPacket` (and its `DecodedPacket`/`PacketPayload` mirrors), and wire collection into `HealthKitManager`.

- **Placeholder identifiers:** bundle ID (`none.BEAT`) and the residual `InsSense` usage-description string (§5) should be cleaned up before any App Store or TestFlight distribution.

---

*This document should live alongside the code (e.g. as `README.md` in the repo root) and be updated as a running log rather than rewritten from scratch.*
