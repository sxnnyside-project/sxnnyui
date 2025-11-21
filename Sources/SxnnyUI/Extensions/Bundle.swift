//
//  Bundle.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//

import Foundation

// MARK: - Bundle Metadata

public extension Bundle {
    /// The display name of the app or bundle.
    ///
    /// This value is derived in the following order:
    /// 1. `CFBundleDisplayName`
    /// 2. `CFBundleName`
    ///
    /// If neither key is present, returns `"Unknown"`.
    @inlinable
    var displayName: String {
        object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        ?? object(forInfoDictionaryKey: "CFBundleName") as? String
        ?? "Unknown"
    }

    /// The marketing version of the app or bundle (e.g., "1.2.3").
    ///
    /// Reads `CFBundleShortVersionString`. If unavailable, returns `"1.0"`.
    @inlinable
    var version: String {
        object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }

    /// The build number of the app or bundle (e.g., "42").
    ///
    /// Reads `CFBundleVersion`. If unavailable, returns `"1"`.
    @inlinable
    var build: String {
        object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? "1"
    }

    /// The Swift version string recorded in the bundle’s Info.plist, if present.
    ///
    /// Looks for the custom key `SwiftVersion`.
    @inlinable
    var swiftVersion: String? {
        object(forInfoDictionaryKey: "SwiftVersion") as? String
    }

    // MARK: - Bundle Size

    /// The size of the bundle on disk, formatted as a human‑readable string.
    ///
    /// Uses `ByteCountFormatter` with `.file` style.
    @inlinable
    var formattedAppSize: String {
        let url = bundleURL
        return ByteCountFormatter.string(fromByteCount: url.directorySize, countStyle: .file)
    }

    /// The size of the bundle on disk in bytes.
    @inlinable
    var appSizeInBytes: Int64 {
        bundleURL.directorySize
    }
}

// MARK: - URL Directory Size

public extension URL {
    /// Calculates the total size of the directory at the URL, including all contents, in bytes.
    ///
    /// - Important: If the URL is not a file URL or cannot be enumerated, this returns `0`.
    /// - Returns: The cumulative size in bytes.
    @inlinable
    var directorySize: Int64 {
        guard isFileURL else { return 0 }

        var totalSize: Int64 = 0
        let fileManager = FileManager.default

        // We request file size information during enumeration to avoid repeated metadata fetches.
        if let enumerator = fileManager.enumerator(
            at: self,
            includingPropertiesForKeys: [.isRegularFileKey, .fileSizeKey],
            options: [.skipsHiddenFiles]
        ) {
            for case let fileURL as URL in enumerator {
                // Safely extract file attributes; skip entries we can’t read.
                guard
                    let values = try? fileURL.resourceValues(forKeys: [.isRegularFileKey, .fileSizeKey]),
                    values.isRegularFile == true
                else { continue }

                if let fileSize = values.fileSize {
                    totalSize += Int64(fileSize)
                }
            }
        }

        return totalSize
    }
}
