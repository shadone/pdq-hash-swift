//
// Copyright (c) 2025, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: MIT
//

#if canImport(AppKit)

import AppKit
import CPDQ

public extension PDQ {
    static func hash(image: NSImage) throws -> PDQ {
        let (data, width, height) = imageToLumaData(image: image)

        var hash = [UInt16](repeating: 0, count: 16)
        var quality: Int32 = 0

        let result = data.withUnsafeBytes { pdata in
            pdqFromLumaData(
                data: pdata,
                numRows: Int32(height),
                numCols: Int32(width),
                hash: &hash,
                quality: &quality
            )
        }

        // This code crashes with EXC_BAD_ACCESS
//        let result = withUnsafePointer(to: data) { pdata in
//            pdata.withMemoryRebound(to: Float32.self, capacity: width * height) { pfloat in
//                pdqFromLumaData(
//                    data: pfloat,
//                    numRows: Int32(height),
//                    numCols: Int32(width),
//                    hash: &hash,
//                    quality: &quality
//                )
//            }
//        }

        if result != 0 {
            throw PDQError.unknown
        }

        return PDQ(hash: (
            hash[0], hash[1], hash[2], hash[3],
            hash[4], hash[5], hash[6], hash[7],
            hash[8], hash[9], hash[10], hash[11],
            hash[12], hash[13], hash[14], hash[15],
        ), quality: Int(quality))
    }
}

func imageToLumaData(image: NSImage) -> (Data, width: Int, height: Int) {
    let newWidth: Int
    let newHeight: Int

    if (image.size.width > 512 || image.size.height > 512) {
        // scale the image down to fit 512x512 without preserving aspect ratio.
        newWidth = 512
        newHeight = 512
    } else {
        newWidth = Int(image.size.width)
        newHeight = Int(image.size.height)
    }

    let newSize = NSSize(
        width: newWidth,
        height: newHeight
    )

    let colorspace = CGColorSpaceCreateDeviceRGB()

    var data = Data(count: newWidth * newHeight * 4)
    data.withUnsafeMutableBytes { pdata in
        let context = CGContext(
            data: pdata,
            width: newWidth,
            height: newHeight,
            bitsPerComponent: 8,
            bytesPerRow: newWidth * 4,
            space: colorspace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )

        assert(context != nil)

        var rect = NSRect(origin: .zero, size: newSize)
        let cgimage = image.cgImage(forProposedRect: &rect, context: nil, hints: nil)
        context?.draw(cgimage!, in: NSRect(origin: .zero, size: newSize))

        let resizedImage = NSImage(cgImage: context!.makeImage()!, size: newSize)
        print(resizedImage)
    }

    let floatRGBData = rgbaToLuma(data: data, width: newWidth, height: newHeight)
    return (floatRGBData, width: newWidth, height: newHeight)
}

#endif

