//
//  KeychainError.swift
//  ELKeychain
//
//  Created by Angelo Di Paolo on 6/29/16.
//  Copyright © 2016 Walmart. All rights reserved.
//

import Foundation

enum KeychainError: ErrorType {
    case unexpectedFailure
    case failedToCreateTouchIDAccessControl
    case itemNotFound
    case failedToDeleteItem(status: OSStatus)
    case failedToAddItem(status: OSStatus)
    case failedToCopyItem(status: OSStatus)
    case failedToEncodeStringAsData
    case failedToCreateAccessControl
}
