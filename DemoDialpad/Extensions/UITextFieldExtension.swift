//
//  UITextFieldExtension.swift
//  DemoDialpad
//
//  Created by iapp on 19/06/25.
//

import UIKit

//MARK: - StringInTextFieldEnum
enum StringInTextFieldEnum {
    case lettersAndWhiteSpaces,
         numbersAndLettersAndWhiteSpaces,
         emailAddress,
         numbers,
         decimalNumbers
}

//MARK: - UITextField
extension UITextField {
    func validate(
        withReplacementString string: String, // contains new string added to existing one
        andRange range: NSRange,
        toAllow allowedCharacters: StringInTextFieldEnum?,
        uptoLength length: Int? = nil
    ) -> Bool {
        guard let text = self.text else {
            return false
        }
        
        //https://medium.com/livefront/understanding-swifts-characterset-5a7a89a32b54
        let isStringValid: Bool
        if let allowedCharacters {
            let characterSet: CharacterSet
            switch allowedCharacters {
            case .lettersAndWhiteSpaces:
                characterSet = CharacterSet.letters.union(.whitespaces)
            case .numbersAndLettersAndWhiteSpaces:
                characterSet = CharacterSet.alphanumerics.union(.whitespaces)
            case .emailAddress:
                characterSet = CharacterSet(charactersIn: "-_.@").union(.alphanumerics)
            case .numbers:
                characterSet = CharacterSet.decimalDigits
            case .decimalNumbers:
                let occurrenciesOfDot = text.filter { $0 == "." }.count
                if occurrenciesOfDot > 0 &&
                    string == "." {
                    return false
                }
                characterSet = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "."))
            }
            
            let rangeOfInvalidCharacters = string.rangeOfCharacter(from: characterSet.inverted)
            isStringValid = rangeOfInvalidCharacters == nil
        } else {
            isStringValid = true
        }
        
        if let length {
            let newLength: Int = text.count + string.count - range.length
            return (isStringValid && (newLength <= length))
        }
        return isStringValid
    }
}
