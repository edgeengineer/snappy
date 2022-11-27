# ``Snappy``

This library is an implementation of Google's fast compression/decompression library Snappy in Swift.

## Overview

Snappy is a compression/decompression library. 
It does not aim for maximum compression, or compatibility with any other compression library; instead, it aims for very high speeds and reasonable compression. 
For instance, compared to the fastest mode of zlib, Snappy is an order of magnitude faster for most inputs, but the resulting compressed files are anywhere from 20% to 100% bigger.

Snappy has the following properties:

- Fast: Compression speeds at 250 MB/sec and beyond, with no assembler code. See "Performance" below.
- Stable: Over the last few years, Snappy has compressed and decompressed petabytes of data in Google's production environment. The Snappy bitstream format is stable and will not change between versions.
- Robust: The Snappy decompressor is designed not to crash in the face of corrupted or malicious input.
- Free and open source software: Snappy is licensed under a BSD-type license. For more information, see the included COPYING file.

Snappy has previously been called "Zippy" in some Google presentations and the like.

## Performance

Snappy is intended to be fast. On a single core of a Core i7 processor in 64-bit mode, it compresses at about 250 MB/sec or more and decompresses at about 500 MB/sec or more. 
(These numbers are for the slowest inputs in our benchmark suite; others are much faster.) 
In Google's tests, Snappy usually is faster than algorithms in the same class (e.g. LZO, LZF, QuickLZ, etc.) while achieving comparable compression ratios.

Typical compression ratios (based on the benchmark suite) are about 1.5-1.7x for plain text, about 2-4x for HTML, and of course 1.0x for JPEGs, PNGs and other already-compressed data. 
Similar numbers for zlib in its fastest mode are 2.6-2.8x, 3-7x and 1.0x, respectively. 
More sophisticated algorithms are capable of achieving yet higher compression rates, although usually at the expense of speed. 
Of course, compression ratio will vary significantly with the input.

Although Snappy should be fairly portable, it is primarily optimized for 64-bit processors, and may run slower in other environments. In particular:

- Snappy uses 64-bit operations in several places to process more data at once than would otherwise be possible.
- Snappy assumes unaligned 32 and 64-bit loads and stores are cheap. On some platforms, these must be emulated with single-byte loads and stores, which is much slower.
- Snappy assumes little-endian throughout, and needs to byte-swap data in several places if running on a big-endian platform.

## Usage

There are many other methods available to compress and uncompress data besides the ones below. 
But these are mostly for backwards compatibility. 

I do recommend using the asynchronous and throwing versions, if you can do so.

### Compression

#### With concurrency support

```swift
let data = <#data: Data#>
let compressedData = try await data.compressedUsingSnappy() 
```

#### Without concurrency support

```swift
let data = <#data: Data#>
let compressedData = try data.compressedUsingSnappy() // Do not call this from main thread, it will block the thread 
```

### Uncompression

#### With concurrency support

```swift
let data = <#data: Data#>
let uncompressedData = try await data.uncompressedUsingSnappy() 
```

#### Without concurrency support

```swift
let data = <#data: Data#>
let uncompressedData = try data.uncompressedUsingSnappy() // Do not call this from main thread, it will block the thread 
```

## Topics

### Essentials
<!-- 
The following references are currently not supported by DocC, but will be in the near future. 
This is because everything in swift-snappy is extensions for Data and String. 
-->
- ``Data``
- ``String``


