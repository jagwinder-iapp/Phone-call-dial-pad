//
//  BundleExtension.swift
//  DemoDialpad
//
//  Created by iapp on 19/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//

import Foundation

//MARK: - Bundle
extension Bundle {
    // Name of the app - title under the icon.
    var displayName: String {
        return (object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
                object(forInfoDictionaryKey: "CFBundleName") as? String) ?? "Second Line"
    }
}
