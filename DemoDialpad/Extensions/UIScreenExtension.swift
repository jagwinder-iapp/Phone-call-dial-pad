//
//  UIScreenExtension.swift
//  DemoDialpad
//
//  Created by iapp on 19/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//

import UIKit

extension UIScreen {
    static let shared: UIScreen = UIApplication.shared.activeKeyWindow?.screen ?? main
    
    var screenWidth: Double {
        return bounds.size.width
    }
    
    var screenHeight: Double {
        return bounds.size.height
    }
    
    var screenMaxLength: Double {
        return max(screenWidth, screenHeight)
    }
    
    enum DeviceSizeEnum {
        case small, medium, large
    }
    
    var getDeviceSizeEnum: DeviceSizeEnum {
        // print(screenMaxLength)
        switch screenMaxLength {
        case 0..<668:  // Small devices (iPhone SE)
            return .small
        case 668..<931: // Medium devices (iPhone 11, iPhone 14)
            return .medium
        case 931...:  // Large devices (iPhone 14 Pro Max, iPads)
            return .large // No change
        default:
            return .small
        }
    }
}
