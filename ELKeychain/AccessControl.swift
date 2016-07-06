//
//  AccessControl.swift
//  ELKeychain
//
//  Created by Angelo Di Paolo on 7/6/16.
//  Copyright © 2016 Walmart. All rights reserved.
//

import Foundation

public struct AccessControl: AccessControlConvertible {
    public let accessControl: SecAccessControl
    
    public init(protection: AccessControlProtectionPolicy, policy: SecAccessControlCreateFlags) throws {
        var accessControlError: Unmanaged<CFError>?
        
        guard let control = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                            protection.rawValue,
                                                            policy,
                                                            &accessControlError)
        else { throw KeychainError.failedToCreateAccessControl }
        
        self.accessControl = control
    }
}
