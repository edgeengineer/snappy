# Snappy

[![Tests](https://github.com/lovetodream/swift-snappy/actions/workflows/tests.yml/badge.svg)](https://github.com/lovetodream/swift-snappy/actions/workflows/tests.yml)
[![Docs](https://github.com/lovetodream/swift-snappy/actions/workflows/deploy_docs.yml/badge.svg)](https://github.com/lovetodream/swift-snappy/actions/workflows/deploy_docs.yml)

This library is an implementation of Google's fast compression/decompression library Snappy in Swift. It Supports Darwin (macOS), Linux platforms, iOS, watchOS and tvOS.

## Add dependency

### Swift Package

Add `Snappy` to the dependencies within your application's `Package.swift` file.

```swift
.package(url: "https://github.com/lovetodream/swift-snappy.git", from: "1.0.0"),
```

Add `Snappy` to your target's dependencies.

```swift
.product(name: "Snappy", package: "swift-snappy"),
``` 

### Xcode Project

Go to `File` > `Add Packages`, enter the Package URL `https://github.com/lovetodream/swift-snappy.git` and press `Add Package`.


## Documentation and Usage

The documentation and usage examples are available via the [API reference](https://timozacherl.com/swift-snappy/documentation/snappy/).

## License

The swift-snappy code is under the same license as the original snappy source code. Full license text is available in [LICENSE](https://github.com/lovetodream/swift-snappy/blob/main/LICENSE).
