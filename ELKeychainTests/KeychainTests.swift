//
//  KeychainTests.swift
//  ELKeychain
//
//  Created by Angelo Di Paolo on 5/31/16.
//  Copyright © 2016 Walmart. All rights reserved.
//

import XCTest
import ELKeychain

class KeychainTests: XCTestCase {
    func test_setString_returnsTrueWhenStoringKeychainItem() {
        let value = "test_set_returnsTrueWhenStoringKeychainItem-value"
        
        let status = Keychain.set(value, account: "set-test-account", service: "set-test-service")
        
        XCTAssertTrue(status)
        
        // cleanup
        Keychain.delete(account: "set-test-account", service: "set-test-service")
    }
    
    func test_getString_returnsKeychainItemForValidQuery() {
        let value = "test_get_returnsKeychainItemForValidQuery-value"
        Keychain.set(value, account: "get-test-account", service: "get-test-service")
        
        let result: String? = Keychain.get(account: "get-test-account", service: "get-test-service")
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, value)
        
        Keychain.delete(account: "get-test-account", service: "get-test-account")
    }
    
    func test_getData_returnsNilWhenKeychainItemIsMissing() {
        let account = "test_getData_returnsNilWhenKeychainItemIsMissing-account"
        let service = "test_getData_returnsNilWhenKeychainItemIsMissing-service"
        
        let data: NSData? = Keychain.get(account: account, service: service)
        
        XCTAssertNil(data)
    }
    
    func test_getData_returnsNilAfterItemIsDeleted() {
        let value = "test_getData_returnsNilAfterItemIsDeleted-value"
        let account = "test_getData_returnsNilAfterItemIsDeleted-account"
        let service = "test_getData_returnsNilAfterItemIsDeleted-service"
        Keychain.set(value, account: account, service: service)
        Keychain.delete(account: account, service: service)
        
        let data: NSData? = Keychain.get(account: account, service: service)
        
        XCTAssertNil(data)
    }
    
    func test_delete_returnsTrueWhenDeletingKeychainItem() {
        let value = "test_delete_returnsTrueWhenDeletingKeychainItem-value"
        let account = "test_delete_returnsTrueWhenDeletingKeychainItem-account"
        let service = "test_delete_returnsTrueWhenDeletingKeychainItem-service"
        Keychain.set(value, account: account, service: service)
        
        let status = Keychain.delete(account: account, service: service)
        
        XCTAssertTrue(status)
    }
    
    func test_delete_returnsFalseWhenUnableToDeleteItem() {
        let account = "test_delete_returnsFalseWhenUnableToDeleteItem-account"
        let service = "test_delete_returnsFalseWhenUnableToDeleteItem-service"
        
        let status = Keychain.delete(account: account, service: service)
        
        XCTAssertFalse(status)
    }
}
