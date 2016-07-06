//
//  AccessControlConvertible.swift
//  ELKeychain
//
//  Created by Angelo Di Paolo on 7/6/16.
//  Copyright © 2016 Walmart. All rights reserved.
//

import Foundation

public protocol AccessControlConvertible {
    var accessControl: SecAccessControl {get}
}

extension SecAccessControl: AccessControlConvertible {
    public var accessControl: SecAccessControl {
        return self
    }
}
