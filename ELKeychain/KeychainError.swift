//
//  KeychainError.swift
//  ELKeychain
//
//  Created by Angelo Di Paolo on 6/29/16.
//  Copyright © 2016 Walmart. All rights reserved.
//

import Foundation

public enum KeychainError: Error {
    case unexpectedFailure
    case failedToEncodeStringAsData
    case failedToCreateAccessControl
    case userCanceled
    case badRequest
    case keychainNotAvailable
    case duplicateItem
    case itemNotFound
    case interactionNotAllowed
    case decodeFailure
    case authenticationFailure
    case badParameters

    init?(status: OSStatus) {
        switch status {
        case errSecSuccess: return nil
        case errSecParam: self = .badParameters
        case errSecUserCanceled: self = .userCanceled
        case errSecBadReq: self = .badRequest
        case errSecNotAvailable: self = .keychainNotAvailable
        case errSecDuplicateItem: self = .duplicateItem
        case errSecItemNotFound: self = .itemNotFound
        case errSecInteractionNotAllowed: self = .interactionNotAllowed
        case errSecDecode: self = .decodeFailure
        case errSecAuthFailed: self = .authenticationFailure
        default: self = .unexpectedFailure
        }
    }
}
