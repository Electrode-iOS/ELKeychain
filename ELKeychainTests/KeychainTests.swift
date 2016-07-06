//
//  KeychainTests.swift
//  ELKeychain
//
//  Created by Angelo Di Paolo on 5/31/16.
//  Copyright © 2016 Walmart. All rights reserved.
//

import XCTest
import ELKeychain

private let testServiceName = "ELKeychainTests-test-service"

class KeychainTests: XCTestCase {
    func removeTestKeychainItems() {
        let query = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrService as String : testServiceName]
        
        let _ = try? Keychain.delete(matching: query)   
    }
    
    override func setUp() {
        removeTestKeychainItems()
    }
    
    func test_setString_doesNotThrowErrors() {
        let value = "value"
        let account = "test_setString_doesNotThrowErrors"
        
        do {
            try Keychain.set(value, account: account, service: testServiceName)
        } catch let error {
            XCTFail("Unexpected error. \(error)")
        }
        
        // cleanup
        try! Keychain.delete(account: account, service: testServiceName)
    }
    
    func test_getString_returnsKeychainItemForValidQuery() {
        let value = "value"
        let account = "test_getString_returnsKeychainItemForValidQuery"
        var result: String?
        
        try! Keychain.set(value, account: account, service: testServiceName)

        do {
            result = try Keychain.get(account: account, service: testServiceName)
        } catch let error {
            XCTFail("Unexpected error. \(error)")
        }
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, value)
        
        try! Keychain.delete(account: account, service: testServiceName)
    }
    
    func test_getData_returnsNilWhenKeychainItemIsNotFound() {
        let account = "test_getData_returnsNilWhenKeychainItemIsNotFound-account"
        
        do {
            let result: NSData? = try Keychain.get(account: account, service: testServiceName)
            XCTAssertNil(result)
        } catch {
            XCTFail("Unexpected error. \(error)")
        }
    }
    
    func test_getData_returnsNilAfterItemIsDeleted() {
        let value = "test_getData_returnsNilAfterItemIsDeleted-value"
        let account = "test_getData_returnsNilAfterItemIsDeleted-account"
       
        do {
            try Keychain.set(value, account: account, service: testServiceName)
            try Keychain.delete(account: account, service: testServiceName)
            
            let data: NSData? = try Keychain.get(account: account, service: testServiceName)

            XCTAssertNil(data)
        } catch let error {
            XCTFail("Unexpected error. \(error)")

        }
    }
    
    func test_delete_doesNotThrowErrorWhenDeletingKeychainItem() {
        let value = "test_delete_doesNotThrowErrorWhenDeletingKeychainItem-value"
        let account = "test_delete_doesNotThrowErrorWhenDeletingKeychainItem-account"
        let keychain = Keychain(service: testServiceName)
        
        do {
            try keychain.set(value, account: account)
        } catch let error {
            XCTFail("set call should not fail. Unexpected error. \(error)")
        }
        
        do {
            try keychain.delete(account: account)
            
        } catch let error {
            XCTFail("delete call should not fail. Unexpected error. \(error)")
        }
        
    }
    
    func test_delete_throwsErrorWhenUnableToDeleteItem() {
        let account = "test_delete_throwsErrorWhenUnableToDeleteItem-account"
        
        do {
            try Keychain.delete(account: account, service: testServiceName)
            XCTFail("Expected delete call to throw error")
        } catch _ {
            
        }
    }
}
