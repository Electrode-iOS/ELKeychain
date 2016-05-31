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
    /**
     Store a generic password item for a given account and service.
     
     - parameter account: The account name to store the password item under.
     - parameter service: The service associated with the password item.
     - returns: Returns true if the password was stored successfully.
    */
    public static func set(data: NSData, account: String, service: String) -> Bool {
        let query = [kSecClass as String: kSecClassGenericPassword,
                     kSecAttrAccount as String: account,
                     kSecAttrService as String: service,
                     kSecValueData as String: data]
        
        SecItemDelete(query)
        let status = SecItemAdd(query, nil)
        
        return status == noErr
    }
    
    /**
     Retrieve a generic password item for a given account and service.
     
     - parameter account: The account name to store the password item under.
     - parameter service: The service associated with the password item.
     - returns: The generic password value if found. Returns nil when the password cannot be found.
    */
    public static func get(account account: String, service: String) -> NSData? {
        let query = [kSecClass as String : kSecClassGenericPassword,
                     kSecAttrAccount as String : account,
                     kSecAttrService as String: service,
                     kSecReturnData as String : kCFBooleanTrue,
                     kSecMatchLimit as String : kSecMatchLimitOne]
        
        var result: AnyObject?
        let status = withUnsafeMutablePointer(&result) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        
        switch status {
            
        case errSecSuccess:
            // TODO: test downcast first and throw error if it fails to distinguish this case from a nil return meaning not found
            return result as? NSData
            
        case errSecItemNotFound:
            return nil
            
        default:
            // TODO: throw an error to indicate unexpected failure?
            return nil
        }
    }
    
    /**
     Delete a generic password item.
     
     - parameter account: The account name of the password to delete.
     - parameter service: The service associated with the password item.
     - returns: Returns true if the password was deleted successfully.
     */
    public static func delete(account account: String, service: String) -> Bool {
        let query = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : account,
            kSecAttrService as String : service]
        
        let status = SecItemDelete(query)
        
        return status == noErr
    }
}

extension Keychain {
    /**
     Store a generic password string for a given account and service.
     
     - parameter account: The account name to store the password item under.
     - parameter service: The service associated with the password item.
     - returns: Returns true if the password was stored successfully.
    */
    public static func set(value: String, account: String, service: String) -> Bool {
        guard let data = value.dataUsingEncoding(NSUTF8StringEncoding) else {
            return false
        }
        
        return self.set(data, account: account, service:  service)
    }
    
    /**
     Retrieve a generic password string for a given account and service.
     
     - parameter account: The account name to store the password item under.
     - parameter service: The service associated with the password item.
     - returns: The generic password string if found. Returns nil when the password cannot be found.
    */
    public static func get(account account: String, service: String) -> String? {
        guard let data: NSData = self.get(account: account, service: service) else {
            return nil
        }
        
        return NSString(data: data, encoding: NSUTF8StringEncoding) as? String
    }
}
