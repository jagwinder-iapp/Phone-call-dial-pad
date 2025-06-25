//
//  HapticManager.swift
//  DemoDialpad
//
//  Created by iapp on 18/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//

import Foundation
import UIKit

class HapticManager {

    // Shared instance for easy access
    static let shared = HapticManager()

    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private let impactSoft = UIImpactFeedbackGenerator(style: .soft) // iOS 13+
    private let impactRigid = UIImpactFeedbackGenerator(style: .rigid) // iOS 13+
    private let notificationSuccess = UINotificationFeedbackGenerator()
    private let notificationWarning = UINotificationFeedbackGenerator()
    private let notificationError = UINotificationFeedbackGenerator()
    private let selection = UISelectionFeedbackGenerator()

    private init() {
         impactLight.prepare()
         impactMedium.prepare()
         impactHeavy.prepare()
         if #available(iOS 13.0, *) {
             impactSoft.prepare()
             impactRigid.prepare()
         }
         notificationSuccess.prepare()
         notificationWarning.prepare()
         notificationError.prepare()
         selection.prepare()
    }

    /// Triggers an impact feedback simulating physical impacts.
    /// - Parameter style: The intensity of the impact (.light, .medium, .heavy, .soft, .rigid).
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        // guard UserDefaults.enabledHaptic == true else { return }

        switch style {
        case .light: impactLight.impactOccurred()
        case .medium: impactMedium.impactOccurred()
        case .heavy: impactHeavy.impactOccurred()
        // For iOS 13+ specific styles
        case .soft:
            if #available(iOS 13.0, *) { impactSoft.impactOccurred() } else { impactLight.impactOccurred() } // Fallback
        case .rigid:
            if #available(iOS 13.0, *) { impactRigid.impactOccurred() } else { impactHeavy.impactOccurred() } // Fallback
        @unknown default:
            impactMedium.impactOccurred() // Sensible default
        }
         // impactLight.prepare() // etc. - Decide based on usage patterns
    }

    /// Triggers notification feedback simulating successes, failures, or warnings.
    /// - Parameter type: The type of notification (.success, .warning, .error).
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        // guard UserDefaults.enabledHaptic == true else { return }

        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }

    /// Triggers selection feedback simulating picking an item or changing a setting.
    func selectionChanged() {
        // guard UserDefaults.enabledHaptic == true else { return }

        selection.prepare()
        selection.selectionChanged()
    }
}
