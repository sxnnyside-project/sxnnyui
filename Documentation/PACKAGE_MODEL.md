# Package Model

> Normative for the *destination*, not for present-day action. Defines the long-term package/module model so future epics evolve toward one target instead of repeatedly restructuring.
> Authority: [ARCHITECTURE.md](ARCHITECTURE.md) §5; [VISION.md](VISION.md) §13 ("We will not build an ecosystem").

This document describes the package model. It does not implement it. No target is split, no `Package.swift` change is made as a consequence of this document alone.

---

## 1. Current Package Structure

```swift
// swift-tools-version: 6.0
Package(
    name: "SxnnyErgo",
    platforms: [.iOS(.v15), .macOS(.v12), .tvOS(.v15), .watchOS(.v8), .visionOS(.v1)],
    products: [.library(name: "SxnnyErgo", targets: ["SxnnyErgo"])],
    targets: [
        .target(name: "SxnnyErgo", dependencies: []),
        .testTarget(name: "SxnnyErgoTests", dependencies: ["SxnnyErgo"]),
    ]
)
```

One product, one target, containing all six domains defined in [PRODUCT_DOMAINS.md](PRODUCT_DOMAINS.md), organized internally per [ARCHITECTURE.md](ARCHITECTURE.md) §1. This is correct for the package's current size and is not changed by this document.

## 2. Possible Future Package Separation

A single-target model stops being appropriate when any of the following becomes true for a specific domain:

- **Compile-time cost.** The domain's source volume measurably slows full-package compilation for consumers who use only unrelated domains.
- **Dependency divergence.** The domain needs a platform-conditional dependency (e.g., a UIKit bridge) that the rest of the package does not need, and that dependency's presence in the single target forces unnecessary conditional compilation complexity elsewhere.
- **Audience divergence.** A meaningful fraction of consumers want exactly one domain and explicitly do not want the rest (evidenced by real user requests, not speculation).

None of these conditions are currently met. When one is met for a specific, named domain, the response is to extract **that domain only** into its own target — not to preemptively split all six.

### Target model when splitting occurs

```
Package(
    name: "SxnnyErgo",
    products: [
        .library(name: "SxnnyErgo", targets: ["SxnnyErgo"]),       // umbrella, re-exports everything
        .library(name: "SxnnyErgoModifiers", targets: ["Modifiers"]),
        .library(name: "SxnnyErgoBindings", targets: ["Bindings"]),
        // ... one product per extracted domain, added only as each is actually extracted
    ],
    targets: [
        .target(name: "Modifiers", dependencies: []),
        .target(name: "Bindings", dependencies: []),
        .target(name: "SxnnyErgo", dependencies: ["Modifiers", "Bindings", /* ... */]),
        .testTarget(name: "SxnnyErgoTests", dependencies: ["SxnnyErgo"]),
    ]
)
```

- The umbrella product `SxnnyErgo` always exists and always re-exports every domain target, so `import SxnnyErgo` continues to work exactly as it does today — extraction into per-domain targets is additive from a consumer's point of view, never a breaking change to the default import path.
- A consumer who wants only one domain may `import SxnnyErgoModifiers` directly once that product exists, but is never required to.
- Target names match domain folder names exactly (per [ARCHITECTURE.md](ARCHITECTURE.md) §1 and [NAMING.md](NAMING.md) §2). Product names are `SxnnyErgo<Domain>`.

## 3. Module Responsibilities

Should extraction occur, each domain target owns exactly what [PRODUCT_DOMAINS.md](PRODUCT_DOMAINS.md) assigns it and nothing else — module boundaries are a mechanical consequence of domain boundaries already defined, not a separate design exercise. The dependency-direction rules in [ARCHITECTURE.md](ARCHITECTURE.md) §3 (primitives before composites; `Collections`/`Strings` depend on nothing else; `Platform` may depend on `Modifiers`) become literal target dependency edges in `Package.swift` at that point.

A shared internal target (`SxnnyErgoInternal`, corresponding to the `Internal/` folder in [ARCHITECTURE.md](ARCHITECTURE.md) §7) may exist to hold cross-domain internal helpers, and is never exposed as a public product.

## 4. Export Policy

- The umbrella `SxnnyErgo` product is the only product most consumers ever need and is documented as the default recommendation in the README, regardless of how many per-domain products exist internally.
- A per-domain product is exported (added to `products:`) only once that domain has actually been extracted into its own target — a target is never split without also being exposed as its own product; splitting for internal organization alone with no consumer-facing benefit is not a goal in itself.
- No product re-exports another unrelated product's symbols. The umbrella re-exports every domain; a domain product re-exports nothing but itself.

## 5. Dependency Rules

- Zero third-party dependencies. This has been true and remains true regardless of target structure — per [VISION.md](VISION.md) §13, the package does not build an ecosystem or a large dependency graph. Any proposal to add a third-party dependency requires revisiting this document explicitly, not a routine PR decision.
- Test targets may depend on testing-only helper libraries (e.g., snapshot-testing utilities) without those being considered a "package dependency" in the product sense, but any such addition is still documented in this file when it happens, since it affects contributor setup.
- Inter-target dependencies within the package follow [ARCHITECTURE.md](ARCHITECTURE.md) §3's direction rules exactly — a domain target's `dependencies:` array in `Package.swift` must be derivable by reading that section, not decided ad hoc at split time.

---

## Non-Goals

- This package will not become a monorepo of unrelated products under one umbrella name ([VISION.md](VISION.md) §13).
- This package will not introduce a plugin system or dynamic module loading.
- Target extraction is never performed "for tidiness" alone — it happens only when §2's triggers are actually met, documented in the PR that performs the split with the specific trigger cited.
