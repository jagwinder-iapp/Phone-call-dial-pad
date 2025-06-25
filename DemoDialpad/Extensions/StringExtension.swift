//
//  StringExtensions.swift
//  DemoDialpad
//
//  Created by iapp on 19/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//

import Foundation

extension String {
    var trim: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    var isValidPhoneNumber: Bool {
        if !self.isEmpty {
            let details = self.breakNumber()
            let numberCount = details.number.count
            if numberCount > 6, numberCount < 13 {
                return true
            }
        }
        return false
    }
    
    var filterPhoneNumber: Self {
        let allowedCharacters = CharacterSet(charactersIn: "+0123456789")
        let filtered = self.unicodeScalars.filter { allowedCharacters.contains($0) }
        return String(filtered.prefix(15))
    }
}
