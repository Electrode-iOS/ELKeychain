# ELKeychain

A Swift framework for storing, retrieving, and removing generic password items in the system Keychain.

## Installation


### Carthage

Install with [Carthage](https://github.com/Carthage/Carthage) by adding the framework to your project's [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile).

```
github "Electrode-iOS/ELKeychain" ~> 0.0.1
```

### Manual

Install manually by adding `ELKeychain.xcodeproj` to your project and configuring your target to link `ELKeychain.framework`.


## Usage

### Storing a Password

```
let password = "12345"
let success = Keychain.set(password, account: "king-roland", service: "druidia-airshield")


if success {
  // generic password item stored successfully
} else {
  // failed to store keychain item
}

```

### Retrieving a Password

```
if let password: String = Keychain.get(account: "king-roland", service: "druidia-airshield") {
  Airshield.unlock(password: password)
}
```

### Removing a Password

```
let success = Keychain.delete(account: "king-roland", service: "druidia-airshield")

if success {
  // generic password item deleted successfully
} else {
  // failed to delete generic password item
}

```




