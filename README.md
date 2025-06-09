# Snappy

[![Tests](https://github.com/edgeengineer/snappy/actions/workflows/tests.yml/badge.svg)](https://github.com/edgeengineer/snappy/actions/workflows/tests.yml)
[![Docs](https://github.com/edgeengineer/snappy/actions/workflows/deploy_docs.yml/badge.svg)](https://github.com/edgeengineer/snappy/actions/workflows/deploy_docs.yml)
![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20visionOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux-333333.svg)

This library is an implementation of Google's fast compression/decompression library Snappy in Swift. It supports iOS, macOS, visionOS, tvOS, watchOS, and Linux platforms.

This is a fork of [swift-snappy](https://github.com/lovetodream/swift-snappy) by [@lovetodream](https://github.com/lovetodream). Thank you for creating this excellent library!

## Add dependency

### Swift Package

Add `Snappy` to the dependencies within your application's `Package.swift` file.

```swift
.package(url: "https://github.com/edgeengineer/snappy.git", from: "1.0.0"),
```

Add `Snappy` to your target's dependencies.

```swift
.product(name: "Snappy", package: "snappy"),
``` 

### Xcode Project

Go to `File` > `Add Packages`, enter the Package URL `https://github.com/edgeengineer/snappy.git` and press `Add Package`.

## Usage

### Basic Compression and Decompression

```swift
import Snappy
import Foundation

// Compress data
let originalData = "Hello, Snappy compression!".data(using: .utf8)!
let compressedData = try originalData.compressedUsingSnappy()

// Decompress data
let decompressedData = try compressedData.uncompressedUsingSnappy()
let decompressedString = String(data: decompressedData, encoding: .utf8)!
print(decompressedString) // "Hello, Snappy compression!"
```

### Async Compression

```swift
import Snappy
import Foundation

// Async compression and decompression
let data = "Large text that needs compression...".data(using: .utf8)!

Task {
    let compressed = try await data.compressedUsingSnappy()
    let decompressed = try await compressed.uncompressedUsingSnappy()
}
```

### Error Handling

```swift
import Snappy
import Foundation

let data = "Some data".data(using: .utf8)!

do {
    let compressed = try data.compressedUsingSnappy()
    let decompressed = try compressed.uncompressedUsingSnappy()
} catch {
    print("Compression/decompression failed: \(error)")
}
```

### String Extension

```swift
import Snappy

// Direct string compression (uses UTF-8 encoding)
let compressed = try "Hello, World!".compressedUsingSnappy()
```

## Documentation and Usage

For more detailed documentation and advanced usage examples, see the [API reference](https://edgeengineer.github.io/snappy/documentation/snappy/).

## License

The swift-snappy code is under the same license as the original snappy source code. Full license text is available in [LICENSE](https://github.com/edgeengineer/snappy/blob/main/LICENSE).
