//
//  UIImageExtension.swift
//  DemoDialpad
//
//  Created by iapp on 19/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(forCountryCode countryCode: String) {
        let countryCode = countryCode.uppercased()
        let imageName = "CountryAssets.bundle/" + countryCode + ".png"
        self.init(named: imageName)
    }
    
    //MARK: - Detect Darkness
    func downscaledImage(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    var isDark: Bool {
        guard let cgImage = self.cgImage else { return false }
        let ciImage = CIImage(cgImage: cgImage)
        let extent = ciImage.extent
        let context = CIContext()

        let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.width, w: extent.height)

        guard let filter = CIFilter(name: "CIAreaAverage",
                                    parameters: [kCIInputImageKey: ciImage,
                                                 kCIInputExtentKey: inputExtent]),
              let outputImage = filter.outputImage else {
            return false
        }

        var bitmap = [UInt8](repeating: 0, count: 4)
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: CGColorSpaceCreateDeviceRGB())

        let brightness = (0.299 * Double(bitmap[0]) +
                          0.587 * Double(bitmap[1]) +
                          0.114 * Double(bitmap[2])) / 255.0
        return brightness < 0.5
    }
}
