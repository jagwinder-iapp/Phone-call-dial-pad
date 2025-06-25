//
//  DialNumberVM.swift
//  DemoDialpad
//
//  Created by iapp on 18/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//

import Foundation
import Combine
import Alamofire

enum DialEligibilityError: Error {
    case invalidNumber,
         noNumberBought, noInternetAvailable
}

enum DialCallError: Error {
    case microphonePermissionNotGranted
}

@MainActor
class DialNumberVM: NSObject, ObservableObject {
    
    //MARK: - Call Related Methods Used by UI
    func canDialCall(toNumber number: String) -> Result<Void, DialEligibilityError> {guard number.isValidPhoneNumber else {
            return .failure(.invalidNumber)
        }
        
        guard NetworkReachabilityManager()!.isReachable else {
            return .failure(.noInternetAvailable)
        }
        
        guard UserManager.shared.hasBoughtPhoneNumber() else {
            return .failure(.noNumberBought)
        }
        
        return .success(())
    }
}
