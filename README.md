# ELKeychain

[![Build Status](https://travis-ci.org/Electrode-iOS/ELKeychain.svg?branch=master)](https://travis-ci.org/Electrode-iOS/ELKeychain)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

A Swift framework for storing, retrieving, and removing generic password items in the system Keychain.

## Requirements

ELKeychain requires Swift 4 and Xcode 9.2.

## Installation

### Carthage

Install with [Carthage](https://github.com/Carthage/Carthage) by adding the framework to your project's [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile).

```
github "Electrode-iOS/ELKeychain"
```

### Manual

Install manually by adding `ELKeychain.xcodeproj` to your project and configuring your target to link `ELKeychain.framework`.

There are two target that builds `ELKeychain.framework`.
1. `ELKeychain`: Creates dynamicly linked `ELKeychain.framework.`
2. `ELKeychain_static`: Creates staticly linked `ELKeychain.framework`.

Both targets build the same product (`ELKeychain.framework`), thus linking the same app against both `ELKeychain` and `ELKeychain_static` should be avoided.

## Usage

### Storing a Generic Password Item

```
let password = "12345"

do {
  try Keychain.set(password, account: "king-roland", service: "druidia-airshield")
} catch let error {
    // failed to store keychain item
}

```

### Retrieving a Generic Password Item

```
do {
    if let password: String = try Keychain.get(account: "king-roland", service: "druidia-airshield") {
        Airshield.unlock(password: password)
    } else {
      // unable to find password to unlock
    }
} catch let error {
    // an error occurred while retrieving the keychain item
}


```

### Removing a Generic Password Item

```
do {
    try Keychain.delete(account: "king-roland", service: "druidia-airshield")
} catch let error {
    // an error occurred while trying to delete the keychain item
}

```

### Storing a Generic Password Item w/ Access Control

```
do {
    let accessControl = try AccessControl(protection: .whenPasscodeSetThisDeviceOnly, policy: .UserPresence)
    try Credential.keychain.set("12345", account: "king-roland", accessControl: accessControl)
} catch let error {
    // an error occurred
}

```
