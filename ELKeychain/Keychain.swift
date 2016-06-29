//
//  Keychain.swift
//  ELKeychain
//
//  Created by Angelo Di Paolo on 5/31/16.
//  Copyright © 2016 Walmart. All rights reserved.
//

import Foundation

public struct TouchIDPasswordItem {
    public var account: String
    public var service: String
    public var data: NSData
    public var accessControl: SecAccessControl
    
    public init(data: NSData, account: String, service: String) throws {
        self.data = data
        self.account = account
        self.service = service
        
        var accessControlError: Unmanaged<CFError>?
        
        guard let control = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                            kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                                                            .UserPresence, &accessControlError)
        else { throw KeychainError.failedToCreateAccessControl }
        
        self.accessControl = control
    }
}

/// Provides access to the system keychain for storing, retrieving, and removing generic password items.
public final class Keychain {
    private static func delete(matching query: CFDictionary) throws {
        let status = SecItemDelete(query) // delete first because adding a duplicate item results in an error
        
        if status != noErr {
            throw KeychainError.failedToDeleteItem(status: status)
        }
    }
    
    private static func add(attributes attributes: CFDictionary) throws {
        let status = SecItemAdd(attributes, nil)
        
        if status != noErr {
            throw KeychainError.failedToAddItem(status: status)
        }
    }
    
    private static func copy(matching query: CFDictionary) throws -> AnyObject? {
        var result: AnyObject?
        let status = withUnsafeMutablePointer(&result) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        
        if status != noErr {
            throw KeychainError.failedToCopyItem(status: status)
        }
        
        return result
    }
}

extension Keychain {
    /**
     Store a generic password item for a given account and service.
     
     - parameter data: The data of the generic password item.
     - parameter account: The account name to store the password item under.
     - parameter service: The service associated with the password item.
     - parameter accessControl: The access control settings of the password item.
     */
    public static func set(data: NSData, account: String, service: String, accessControl: SecAccessControl? = nil) throws {
        var attributes: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecValueData as String: data]
                
        if let accessControl = accessControl {
            attributes[kSecAttrAccessControl as String] = accessControl
        }
        
        try delete(matching: attributes)
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

// MARK: - GenericPasswordItem API

extension Keychain {
    public static func set<T: GenericPasswordItemProtocol>(item: T) throws {
        try set(item.data, account: item.account, service: item.service, accessControl: item.accessControl)
    }
    
    public static func get<T: GenericPasswordItemProtocol>(account account: String, service: String) throws -> T? {
        guard let data: NSData = try get(account: account, service: service)
        else { return nil }
        
        return T(data: data, account: account, service: service)
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
    public static func set(value: String, account: String, service: String) throws {
        guard let data = value.dataUsingEncoding(NSUTF8StringEncoding) else {
            throw KeychainError.failedToEncodeStringAsData
        }
        
        return try self.set(data, account: account, service: service)
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
