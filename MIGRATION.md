# Migrating to 2.0.0

SxnnyErgo 2.0.0 is a breaking release. This guide covers what changed and how to update.

---

## 1. Package Rename

The package, module, and repository are renamed from `SxnnyUI` to `SxnnyErgo`.

**`Package.swift`:**

```diff
 dependencies: [
-    .package(url: "https://github.com/Sxnnyside-Project/SxnnyUI.git", from: "1.1.0")
+    .package(url: "https://github.com/Sxnnyside-Project/SxnnyErgo.git", from: "2.0.0")
 ]
```

```diff
 .target(
     name: "YourTarget",
-    dependencies: ["SxnnyUI"]
+    dependencies: ["SxnnyErgo"]
 )
```

**Every source file:**

```diff
-import SxnnyUI
+import SxnnyErgo
```

No public symbol's name changed as a result of the rename — only the module you import.

---

## 2. Removed APIs

The public surface was reviewed domain by domain against [`Documentation/`](Documentation/) and reduced to what meets the bar. There is no direct replacement for a removed symbol unless noted — each was removed because it was out of scope for a SwiftUI ergonomics library (theming, application infrastructure, domain-specific data models), broken, or superseded by a native API. See [CHANGELOG.md](CHANGELOG.md) `[2.0.0]` → `Removed` for the complete, categorized list, including:

- The theming system (`SxnnyTheme`)
- The `Manager/` domain (`AlertManager`, `KeychainManager`)
- The `Utilities/` domain (`ChartData`, `Coordinate`, `IdentifiableImage`, `InspectionItem`, `Token`, `DateFormat`, `TimeFormat`, `FloatFormatter`, `PhoneFormat`, `Logger`) — use native `Date.FormatStyle`, `Double.FormatStyle`, and `os.Logger` instead
- Native-SwiftUI wrapper types with no behavior beyond a default parameter (`SxnnyYStack`, `SxnnyXStack`, `SxnnyZStack`, `SxnnyScaffold`, `SxnnyScrollView`, `SxnnyContainer`, `SxnnyForm`, `SxnnySection`, `SxnnyGrid` and its lazy variants) — use the native SwiftUI type directly
- `FontWeightPicker` and its family, `FocusText`, `ValidationLabel`, `LabelSwipeable`, `TriggeredTextField`, `FocusTextField`, `LabeledTextField`, and the already-deprecated `FillIconButton`/`FitIconButton`/`LabeledIconButton`/`ShadowedRoundedButton`/`TriggerButton`/`ValidationButton`

If your project depends on any of these, pin to `1.1.0` until you've migrated off them, or vendor the specific implementation you need.

---

## 3. Behavior Fixes

Two symbols kept their name and shape but had a functional bug fixed — no code change required on your end, but observable behavior changes:

- `View.animated(if:)` now actually keys its animation off the condition passed in (previously animated unconditionally due to an internal bug).
- `IconButton`'s background gradient no longer contains a dead branch.

See [CHANGELOG.md](CHANGELOG.md) `[2.0.0]` → `Fixed` for details.

---

## 4. Nothing Else Changed

No other public API was renamed or reshaped in this release. If your project only uses symbols not listed in §2, updating the import and the package URL (§1) is the entire migration.
