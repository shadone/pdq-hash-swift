//
// Copyright (c) 2025, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: MIT
//

public struct PDQ: CustomStringConvertible {
    public let rawValue: (
        UInt16,UInt16,UInt16,UInt16,
        UInt16,UInt16,UInt16,UInt16,
        UInt16,UInt16,UInt16,UInt16,
        UInt16,UInt16,UInt16,UInt16
    )

    public let quality: Int

    init(
        hash: (
            UInt16, UInt16, UInt16, UInt16,
            UInt16, UInt16, UInt16, UInt16,
            UInt16, UInt16, UInt16, UInt16,
            UInt16, UInt16, UInt16, UInt16
        ),
        quality: Int
    ) {
        self.rawValue = hash
        self.quality = quality
    }

    public func toString() -> String {
        String(
            format: "%04hx%04hx%04hx%04hx%04hx%04hx%04hx%04hx%04hx%04hx%04hx%04hx%04hx%04hx%04hx%04hx",
            rawValue.15, rawValue.14, rawValue.13, rawValue.12,
            rawValue.11, rawValue.10, rawValue.9, rawValue.8,
            rawValue.7, rawValue.6, rawValue.5, rawValue.4,
            rawValue.4, rawValue.3, rawValue.2, rawValue.1,
        )
    }

    public var description: String { toString() }
}
