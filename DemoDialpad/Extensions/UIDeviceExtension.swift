//
//  UIDeviceExtension.swift
//  DemoDialpad
//
//  Created by iapp on 19/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//

import UIKit

extension UIDevice {
    var isIPad: Bool {
        return userInterfaceIdiom == .pad
    }
}
