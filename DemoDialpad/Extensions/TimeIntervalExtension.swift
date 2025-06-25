//
//  TimeIntervalExtension.swift
//  DemoDialpad
//
//  Created by iapp on 19/06/25.
//

import Foundation

//MARK: - TimeInterval
extension TimeInterval {
    var to24HourTimeFormat: String {
        let hour = Int(self) / 3600
        let minute = Int(self) / 60 % 60
        let second = Int(self) % 60
        
        // return formated string
        if hour > 0 {
            return String(format: "%02i:%02i:%02i", hour, minute, second)
        } else {
            return String(format: "%02i:%02i", minute, second)
        }
    }
}
