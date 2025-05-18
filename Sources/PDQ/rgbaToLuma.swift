//
// Copyright (c) 2025, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: MIT
//

import Foundation

// From Wikipedia: standard RGB to luminance (the 'Y' in 'YUV').
// https://w.wiki/EBWv
let luma_from_R_coeff: Float32 = 0.299
let luma_from_G_coeff: Float32 = 0.587
let luma_from_B_coeff: Float32 = 0.114

func rgbaToLuma(data: Data, width: Int, height: Int) -> Data {
    let pixelCount = width * height
    // newWidth x newHeight x 4 (4 color channels: RGBA 1 byte per channel)
    let expectedLength = pixelCount * 4

    guard data.count == expectedLength else {
        fatalError("Unexpected data size: expected \(expectedLength) bytes, got \(data.count)")
    }

    assert(MemoryLayout<Float32>.size == 4)
    var floatRGBData = Data(capacity: pixelCount * MemoryLayout<Float32>.size)

    data.withUnsafeBytes { (rgbaPointer: UnsafeRawBufferPointer) in
        guard let rgbaBase = rgbaPointer.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
            return
        }

        for i in 0..<pixelCount {
            let offset = i * 4

            let r = rgbaBase[offset + 0]
            let g = rgbaBase[offset + 1]
            let b = rgbaBase[offset + 2]

            let rf = Float32(r)
            let gf = Float32(g)
            let bf = Float32(b)
            let yval = luma_from_R_coeff * rf + luma_from_G_coeff * gf + luma_from_B_coeff * bf

            if i < 5 {
                print("yval: r=\(r) g=\(g) b=\(b) -> \(yval)")
            }

            floatRGBData.append(contentsOf: Swift.withUnsafeBytes(of: yval) { Data($0) })
        }
    }

    return floatRGBData
}
