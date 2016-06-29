//
//  AccessControlProtection.swift
//  ELKeychain
//
//  Created by Angelo Di Paolo on 6/29/16.
//  Copyright © 2016 Walmart. All rights reserved.
//

import Foundation

public enum AccessControlProtection {
    case whenUnlocked
    case afterFirstUnlock
    case always
    case whenPasscodeSetThisDeviceOnly
    case whenUnlockedThisDeviceOnly
    case afterFirstUnlockThisDeviceOnly
    case alwaysThisDeviceOnly
}

extension AccessControlProtection: RawRepresentable {
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecAttrAccessibleWhenUnlocked):                    self = whenUnlocked
        case String(kSecAttrAccessibleAfterFirstUnlock):                self = afterFirstUnlock
        case String(kSecAttrAccessibleAlways):                          self = always
        case String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly):   self = whenPasscodeSetThisDeviceOnly
        case String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly):      self = whenUnlockedThisDeviceOnly
        case String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly):  self = afterFirstUnlockThisDeviceOnly
        case String(kSecAttrAccessibleAlwaysThisDeviceOnly):            self = alwaysThisDeviceOnly
        default: return nil
        }
        
    }
    
    public var rawValue: String {
        switch self {
        case whenUnlocked:                      return String(kSecAttrAccessibleWhenUnlocked)
        case afterFirstUnlock:                  return String(kSecAttrAccessibleAfterFirstUnlock)
        case always:                            return String(kSecAttrAccessibleAlways)
        case whenPasscodeSetThisDeviceOnly:     return String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
        case whenUnlockedThisDeviceOnly:        return String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
        case afterFirstUnlockThisDeviceOnly:    return String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
        case alwaysThisDeviceOnly:              return String(kSecAttrAccessibleAlwaysThisDeviceOnly)
        }
    }
}
