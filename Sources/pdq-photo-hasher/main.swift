//
// Copyright (c) 2025, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: MIT
//

import AppKit
import PDQ

let filepath = "/Users/denis/Downloads/sasha_watermarked_1745421305840.jpg"

let app = NSApplication.shared

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        let image = NSImage(byReferencingFile: filepath)!
        print("### image size: \(image.size)")
        let pdq = try! PDQ.hash(image: image)
        print("### pdq: \(pdq)")
        print("### quality: \(pdq.quality)")
        app.terminate(self)
    }
}

let delegate = AppDelegate()
app.delegate = delegate
app.run()
