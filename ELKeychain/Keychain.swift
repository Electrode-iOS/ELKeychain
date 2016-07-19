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
    
    public func set(data: NSData, account: String, accessControl: AccessControlConvertible? = nil) throws {
        try Keychain.set(data, account: account, service: service)
    }
    
    public func set(value: String, account: String, accessControl: AccessControlConvertible? = nil) throws {
        try Keychain.set(value, account: account, service: service, accessControl: accessControl)
    }
    
    public func get(account account: String) throws -> NSData? {
        return try Keychain.get(account: account, service: service)
    }
    
    public func get(account account: String) throws -> String? {
        return try Keychain.get(account: account, service: service)
    }
    
    public func delete(account account: String) throws {
        try Keychain.delete(account: account, service: service)
    }
}

// MARK: - Core API

extension Keychain {
    public static func add(attributes attributes: CFDictionary) throws {
        let status = SecItemAdd(attributes, nil)
        
        if status != noErr {
            let error = KeychainError(status: status) ?? .unexpectedFailure
            throw error
        }
    }
    
    public static func copy(matching query: CFDictionary) throws -> AnyObject? {
        var result: AnyObject?
        let status = withUnsafeMutablePointer(&result) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        
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
    public static func set(data: NSData, account: String, service: String, accessControl: AccessControlConvertible? = nil) throws {
        var attributes: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecValueData as String: data]
                
        if let accessControl = accessControl?.accessControl {
            attributes[kSecAttrAccessControl as String] = accessControl
        }
        
        _ = try? delete(matching: attributes)
        try add(attributes: attributes)
    }
    
    /**
     Retrieve a generic password item for a given account and service.
     
     - parameter account: The account name to store the password item under.
     - parameter service: The service associated with the password item.
     - returns: The generic password value if found. Returns nil when the password cannot be found.
     */
    public static func get(account account: String, service: String) throws -> NSData? {
        let query = [kSecClass as String : kSecClassGenericPassword,
                     kSecAttrAccount as String : account,
                     kSecAttrService as String: service,
                     kSecReturnData as String : kCFBooleanTrue,
                     kSecMatchLimit as String : kSecMatchLimitOne]
        
        let item = try copy(matching: query)
        
        return item as? NSData
    }
    
    /**
     Delete a generic password item.
     
     - parameter account: The account name of the password to delete.
     - parameter service: The service associated with the password item.
     - returns: Returns true if the password was deleted successfully.
     */
    public static func delete(account account: String, service: String) throws {
        let query = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : account,
            kSecAttrService as String : service]
        
        try delete(matching: query)
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
    public static func set(value: String, account: String, service: String, accessControl: AccessControlConvertible? = nil) throws {
        guard let data = value.dataUsingEncoding(NSUTF8StringEncoding) else {
            throw KeychainError.failedToEncodeStringAsData
        }
        
        try self.set(data, account: account, service: service, accessControl: accessControl)
    }
    
    /**
     Retrieve a generic password string for a given account and service.
     
     - parameter account: The account name to store the password item under.
     - parameter service: The service associated with the password item.
     - returns: The generic password string if found. Returns nil when the password cannot be found.
    */
    public static func get(account account: String, service: String) throws -> String? {
        guard let data: NSData = try self.get(account: account, service: service) else {
            return nil
        }
        
        return NSString(data: data, encoding: NSUTF8StringEncoding) as? String
    }
}
