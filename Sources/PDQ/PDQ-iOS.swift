//
// Copyright (c) 2025, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: MIT
//

#if canImport(UIKit)

import UIKit
import CPDQ

public extension PDQ {
    static func hash(image: UIImage) throws {
        let (data, width, height) = imageToLumaData(image: image)

        var hash = [UInt16](repeating: 0, count: 16)
        var quality: Int32 = 0

        let result = withUnsafePointer(to: data) { pdata in
            pdata.withMemoryRebound(to: Float.self, capacity: width * height) { pfloat in
                pdqFromLumaData(
                    data: pfloat,
                    numRows: Int32(height),
                    numCols: Int32(width),
                    hash: &hash,
                    quality: &quality
                )
            }
        }

        if result != 0 {
            throw PDQError.unknown
        }

        var hashString = ""
        for h in hash.reversed() {
            hashString += String(format: "%04hx", h)
        }
        print("### PDQ hash: \(hashString)")
        print("### PDQ quality: \(quality)")
    }
}

func imageToLumaData(image: UIImage) -> (Data, width: Int, height: Int) {
    let newWidth: Int
    let newHeight: Int
    let dataProvider: CGDataProvider

    // Add debug info
    print("Original image size: \(image.size)")
    print("Original image scale: \(image.scale)")
    print("Original image orientation: \(image.imageOrientation.rawValue)")

    if let cgImage = image.cgImage {
        print("CGImage color space: \(cgImage.colorSpace?.name as Optional<String> ?? "nil")")
        print("CGImage bits per component: \(cgImage.bitsPerComponent)")
        print("CGImage bits per pixel: \(cgImage.bitsPerPixel)")
        print("CGImage bytes per row: \(cgImage.bytesPerRow)")
        print("CGImage alpha info: \(cgImage.alphaInfo.rawValue)")
    }

    if (image.size.width > 512 || image.size.height > 512) {
        // scale the image down to fit 512x512 without preserving aspect ratio.
        newWidth = 512
        newHeight = 512

        let newSize = CGSize(
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

            context?.draw(image.cgImage!, in: CGRect(origin: .zero, size: newSize))
        }

        let floatRGBData = rgbaToLuma(data: data, width: newWidth, height: newHeight)
        return (floatRGBData, width: newWidth, height: newHeight)
    } else {
        newWidth = Int(image.size.width)
        newHeight = Int(image.size.height)
        dataProvider = image.cgImage!.dataProvider!
    }

    // newWidth x newHeight x 4 (4 color channels: RGBA 1 byte per channel)
    let data = dataProvider.data! as Data

    let floatRGBData = rgbaToLuma(data: data, width: newWidth, height: newHeight)
    return (floatRGBData, width: newWidth, height: newHeight)
}

#endif
