//
//  Keychain.swift
//  ELKeychain
//
//  Created by Angelo Di Paolo on 5/31/16.
//  Copyright © 2016 Walmart. All rights reserved.
//

import Foundation

/// Provides access to the system keychain for storing, retrieving, and removing generic password items.
public final class Keychain {
    let service: String
    
    public init(service: String) {
        self.service = service
    }
    
    public func set(_ data: Data, account: String, accessGroup: String? = nil, accessControl: AccessControlConvertible? = nil) throws {
        try Keychain.set(data, account: account, service: service, accessGroup: accessGroup)
    }
    
    public func set(_ value: String, account: String, accessGroup: String? = nil, accessControl: AccessControlConvertible? = nil) throws {
        try Keychain.set(value, account: account, service: service, accessGroup: accessGroup, accessControl: accessControl)
    }
    
    public func get(account: String, accessGroup: String? = nil) throws -> Data? {
        return try Keychain.get(account: account, service: service, accessGroup: accessGroup)
    }
    
    public func get(account: String, accessGroup: String? = nil) throws -> String? {
        return try Keychain.get(account: account, service: service, accessGroup: accessGroup)
    }
    
    public func delete(account: String, accessGroup: String? = nil) throws {
        try Keychain.delete(account: account, service: service, accessGroup: accessGroup)
    }
}

// MARK: - Core API

extension Keychain {
    public static func add(attributes: CFDictionary) throws {
        let status = SecItemAdd(attributes, nil)
        
        if status != noErr {
            let error = KeychainError(status: status) ?? .unexpectedFailure
            throw error
        }
    }
    
    public static func copy(matching query: CFDictionary) throws -> AnyObject? {
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        
        switch status {
            
        case errSecItemNotFound:
            return nil
            
        case errSecSuccess:
            return result
            
        default:
            let error = KeychainError(status: status) ?? .unexpectedFailure
            throw error
        }
    }
    
    public static func delete(matching query: CFDictionary) throws {
        let status = SecItemDelete(query) // delete first because adding a duplicate item results in an error
        
        if status != noErr {
            let error = KeychainError(status: status) ?? .unexpectedFailure
            throw error
        }
    }
}

// MARK: - Convenience API

extension Keychain {
    /**
     Store a generic password item for a given account and service.
     
     - parameter data: The data of the generic password item.
     - parameter account: The account name to store the password item under.
     - parameter service: The service associated with the password item.
     - parameter accessControl: The access control settings of the password item.
     */
    public static func set(_ data: Data, account: String, service: String, accessGroup: String? = nil, accessControl: AccessControlConvertible? = nil) throws {
        var attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecValueData as String: data
        ]
                
        if let accessControl = accessControl?.accessControl {
            attributes[kSecAttrAccessControl as String] = accessControl
        }

        if let accessGroup = accessGroup {
            attributes[kSecAttrAccessGroup as String] = accessGroup
        }
        
        _ = try? delete(matching: attributes as CFDictionary)
        try add(attributes: attributes as CFDictionary)
    }
    
    /**
     Retrieve a generic password item for a given account and service.
     
     - parameter account: The account name to store the password item under.
     - parameter service: The service associated with the password item.
     - returns: The generic password value if found. Returns nil when the password cannot be found.
     */
    public static func get(account: String, service: String, accessGroup: String? = nil) throws -> Data? {
        var query: [String : Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : account,
            kSecAttrService as String: service,
            kSecReturnData as String : (kCFBooleanTrue != nil) as Bool,
            kSecMatchLimit as String : kSecMatchLimitOne
        ]

        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        let item = try copy(matching: query as CFDictionary)
        
        return item as? Data
    }
    
    /**
     Delete a generic password item.
     
     - parameter account: The account name of the password to delete.
     - parameter service: The service associated with the password item.
     - returns: Returns true if the password was deleted successfully.
     */
    public static func delete(account: String, service: String, accessGroup: String? = nil) throws {
        var query: [String : Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : account,
            kSecAttrService as String : service
        ]

        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        try delete(matching: query as CFDictionary)
    }
}

// MARK: - String API

extension Keychain {
    /**
     Store a generic password string for a given account and service.
     
     - parameter account: The account name to store the password item under.
     - parameter service: The service associated with the password item.
     - returns: Returns true if the password was stored successfully.
    */
    public static func set(_ value: String, account: String, service: String, accessGroup: String? = nil, accessControl: AccessControlConvertible? = nil) throws {
        guard let data = value.data(using: String.Encoding.utf8) else {
            throw KeychainError.failedToEncodeStringAsData
        }
        
        try self.set(data, account: account, service: service, accessGroup: accessGroup, accessControl: accessControl)
    }
    
    /**
     Retrieve a generic password string for a given account and service.
     
     - parameter account: The account name to store the password item under.
     - parameter service: The service associated with the password item.
     - returns: The generic password string if found. Returns nil when the password cannot be found.
    */
    public static func get(account: String, service: String, accessGroup: String? = nil) throws -> String? {
        guard let data: Data = try self.get(account: account, service: service, accessGroup: accessGroup) else {
            return nil
        }
        
        return NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
    }
}
