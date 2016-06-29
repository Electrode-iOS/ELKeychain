//
//  GenericPasswordItem.swift
//  ELKeychain
//
//  Created by Angelo Di Paolo on 6/27/16.
//  Copyright © 2016 Walmart. All rights reserved.
//

import Foundation

public protocol GenericPasswordItemProtocol {
    var account: String {get}
    var service: String {get}
    var data: NSData {get}
    var accessControl: SecAccessControl? {get set}
    
    init(data: NSData, account: String, service: String)
}

extension GenericPasswordItemProtocol {
    mutating func configureAccessControl(protection protection: AccessControlProtection, flags: SecAccessControlCreateFlags) throws {
        var accessControlError: Unmanaged<CFError>?
        
        guard let control = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                            protection.rawValue,
                                                            flags, &accessControlError)
        else { throw KeychainError.failedToCreateAccessControl }
        
        self.accessControl = control
    }
}

public struct GenericPasswordItem: GenericPasswordItemProtocol {
    public var account: String
    public var service: String
    public var data: NSData
    public var accessControl: SecAccessControl?
    
    public init(data: NSData, account: String, service: String) {
        self.data = data
        self.account = account
        self.service = service
    }
}
