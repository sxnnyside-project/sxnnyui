//
//  KeychainManager.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//

import Foundation
import Security

/// Errors that can occur during Keychain operations.
public enum KeychainError: Error, Sendable, Equatable {
    /// The provided value could not be converted to or from Data.
    case dataConversionError
    /// The requested item could not be found in the Keychain.
    case itemNotFound
    /// The data retrieved from the Keychain was not in the expected format.
    case unexpectedData
    /// An unexpected OSStatus error code was returned from a Keychain API call.
    case unhandledError(status: OSStatus)
}

/// KeychainManager
///
/// A utility namespace for managing secure storage of sensitive data using the Keychain.
///
/// Provides Data- and String-based helpers for saving, retrieving, and deleting values.
/// You can optionally specify a service name and accessibility level.
///
/// Thread-safety: All functions are synchronous and safe to call from any thread.
///
/// Security note: Keychain data is encrypted and protected by the system.
public enum KeychainManager: Sendable {

    // MARK: - Defaults

    /// Default service name used if none is supplied.
    @usableFromInline
    static let defaultService = Bundle.main.bundleIdentifier ?? "com.sxnnyui.keychain"

    /// Default accessibility attribute.
    @usableFromInline
    static let defaultAccessibility = kSecAttrAccessibleAfterFirstUnlock as String

    // MARK: - Data APIs

    /// Saves data to the Keychain for a given key.
    ///
    /// - Parameters:
    ///   - key: The account key under which the value will be stored.
    ///   - data: The data to store.
    ///   - service: Optional service name to namespace the item.
    ///   - accessibility: Optional Keychain accessibility (e.g., kSecAttrAccessibleAfterFirstUnlock).
    /// - Throws: `KeychainError` on failure.
    @inlinable
    public static func save(
        key: String,
        data: Data,
        service: String = defaultService,
        accessibility: String = defaultAccessibility
    ) throws {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: service,
            kSecAttrAccessible as String: accessibility,
            kSecValueData as String: data
        ]

        // Delete existing item to avoid duplicates.
        SecItemDelete(query as CFDictionary)

        // Add the new item.
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    /// Retrieves data from the Keychain for a given key.
    ///
    /// - Parameters:
    ///   - key: The account key to look up.
    ///   - service: Optional service name used when saving.
    /// - Returns: The stored data.
    /// - Throws: `KeychainError` on failure.
    @inlinable
    public static func get(
        key: String,
        service: String = defaultService
    ) throws -> Data {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: service,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }

        guard status == errSecSuccess, let data = result as? Data else {
            if status == errSecSuccess {
                throw KeychainError.unexpectedData
            } else {
                throw KeychainError.unhandledError(status: status)
            }
        }

        return data
    }

    /// Deletes data from the Keychain for a given key.
    ///
    /// - Parameters:
    ///   - key: The account key to delete.
    ///   - service: Optional service name used when saving.
    /// - Throws: `KeychainError` on failure.
    @inlinable
    public static func delete(
        key: String,
        service: String = defaultService
    ) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: service
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    // MARK: - String convenience

    /// Saves a string to the Keychain for a given key.
    ///
    /// - Parameters:
    ///   - key: The account key under which the value will be stored.
    ///   - value: The string to store (UTF‑8 encoded).
    ///   - service: Optional service name to namespace the item.
    ///   - accessibility: Optional Keychain accessibility (e.g., kSecAttrAccessibleAfterFirstUnlock).
    /// - Throws: `KeychainError` on failure.
    @inlinable
    public static func save(
        key: String,
        value: String,
        service: String = defaultService,
        accessibility: String = defaultAccessibility
    ) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.dataConversionError
        }
        try save(key: key, data: data, service: service, accessibility: accessibility)
    }

    /// Retrieves a string from the Keychain for a given key.
    ///
    /// - Parameters:
    ///   - key: The account key to look up.
    ///   - service: Optional service name used when saving.
    /// - Returns: The stored string (UTF‑8 decoded).
    /// - Throws: `KeychainError` on failure.
    @inlinable
    public static func getString(
        key: String,
        service: String = defaultService
    ) throws -> String {
        let data = try get(key: key, service: service)
        guard let string = String(data: data, encoding: .utf8) else {
            throw KeychainError.unexpectedData
        }
        return string
    }
}
