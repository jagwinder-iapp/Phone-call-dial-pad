//
//  PhoneNumberKitExtensions.swift
//  DemoDialpad
//
//  Created by iapp on 19/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//

import PhoneNumberKit

//MARK: - PhoneNumberKit
extension PhoneNumberUtility {
    static let shared = PhoneNumberUtility()
}

//MARK: - String + PhoneNumberKit
extension String {
    func formatPhoneNumber() -> String {
        let phoneNumberKit = PhoneNumberUtility.shared
        do {
            let parsedPhoneNumber = try phoneNumberKit.parse(self)
            return phoneNumberKit.format(parsedPhoneNumber, toType: .international)
        } catch {
            print("Generic parser error")
            return self
        }
    }
    
    func breakNumber() -> (isdCode: String?, countryCode: String?, number: String) {
        let newNumber = self
        let phoneNumberKit = PhoneNumberUtility.shared
        let number: String
        let isdCode: String?
        let countryCode: String?
        do {
            let phoneNumber = try phoneNumberKit.parse(newNumber)
            let isdCodeInt = phoneNumber.countryCode // For example, 1 for USA
            if let regionCode = phoneNumberKit.getRegionCode(of: phoneNumber) { // For example, US for USA
                let phoneNumberOnly = newNumber.removeISDCode(Int(isdCodeInt))
                number = phoneNumberOnly
                isdCode = "+\(isdCodeInt)" // For example, 1 for USA
                countryCode = regionCode
            } else if isdCodeInt > 0 {
                let phoneNumberOnly = newNumber.removeISDCode(Int(isdCodeInt))
                number = phoneNumberOnly
                isdCode = "+\(isdCodeInt)" // For example, 1 for USA
                countryCode = nil
            } else {
                number = newNumber
                isdCode = nil
                countryCode = nil
            }
        } catch {
            print("Error parsing phone number: \(error)")
            number = newNumber
            isdCode = nil
            countryCode = nil
        }
        
        let finalNum = number
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "*", with: "")
            .replacingOccurrences(of: "+", with: "")
        
        
        return (isdCode, countryCode, finalNum)
    }
    
    func isCountryCodeSame(with secondPhoneNumber: String) -> Bool {
        let firstPhoneNumberData = self.breakNumber()
        let secondPhoneNumberData = secondPhoneNumber.breakNumber()
        
        return firstPhoneNumberData.countryCode == secondPhoneNumberData.countryCode
    }
    
    func removeISDCode(_ isdCode: Int) -> String {
        if self.contains("+"),
           self.hasPrefix("+\(isdCode)") {
            let isdCodeCount = "+\(isdCode)".count
            return String(self.dropFirst(isdCodeCount))
        }
        ///`isdCode` provided by `PhoneNumberKit` does not contain string, so remove country code
        ///by dropping because when using `replacingOccurrences` `isdCode` like 1 will remove 1 from `newNumber` as well
        ///The ISD code is a prefix added for international calls and does not overlap with the starting digits of domestic phone numbers.
        if self.hasPrefix("\(isdCode)") {
            let isdCodeCount = "\(isdCode)".count
            return String(self.dropFirst(isdCodeCount))
        }
        return self
    }
}
