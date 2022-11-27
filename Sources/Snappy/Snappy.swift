import struct Foundation.Data

import SnappyC

public extension Data {
    /// Compresses the given Data using Snappy.
    ///
    /// This method is high-level. If an error occurs in the compression it will silently fail and return nil.
    ///
    /// - Warning: This method will block your current thread.
    ///
    /// - Returns: The snappy-compressed data or nil on error
    func compressedUsingSnappy() -> Data? {
        var compressedDataLength = snappy_max_compressed_length(self.count)
        var environment = snappy_env()
        snappy_init_env(&environment)
        let compressedDataBuffer = self.withUnsafeBytes {
            let compressedDataBuffer = malloc(compressedDataLength)
            let error = snappy_compress(&environment, $0.baseAddress, self.count, compressedDataBuffer, &compressedDataLength)
            debugPrint(error)
            return compressedDataBuffer
        }
        snappy_free_env(&environment)
        guard let compressedDataBuffer else { return nil }
        return Data(bytesNoCopy: compressedDataBuffer, count: compressedDataLength, deallocator: .none)
    }

    /// Uncompresses the given Data using Snappy.
    ///
    /// This method is high-level. If an error occurs in the uncompression it will silently fail and return nil.
    ///
    /// - Warning: This method will block your current thread.
    ///
    /// - Returns: The uncompressed data or nil on error
    func uncompressedUsingSnappy() -> Data? {
        let uncompressedDataLength = self.withUnsafeBytes {
            var uncompressedDataLength: Int = 0
            snappy_uncompressed_length($0.baseAddress, self.count, &uncompressedDataLength)
            return uncompressedDataLength
        }
        let uncompressedDataBuffer = self.withUnsafeBytes {
            let uncompressedDataBuffer = malloc(uncompressedDataLength)
            let error = snappy_uncompress($0.baseAddress, self.count, uncompressedDataBuffer)
            debugPrint(error)
            return uncompressedDataBuffer
        }
        guard let uncompressedDataBuffer else { return nil }
        return Data(bytesNoCopy: uncompressedDataBuffer, count: uncompressedDataLength, deallocator: .none)
    }
}

public extension String {
    /// Compresses the given String using Snappy.
    ///
    /// The String will be encoded to Data using UTF8.
    /// If this is not the behavior you want to use,
    /// encode the String to Data by yourself and call ``Data.compressedUsingSnappy()``.
    ///
    /// This method is high-level. If an error occurs in the compression it will silently fail and return nil.
    ///
    /// - Warning: This method will block your current thread.
    ///
    /// - Returns: The snappy-compressed data or nil on error
    func compressedUsingSnappy() -> Data? {
        self.data(using: .utf8)?.compressedUsingSnappy()
    }
}
