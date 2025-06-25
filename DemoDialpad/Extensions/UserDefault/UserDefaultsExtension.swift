//
//  UserDefaultsExtension.swift
//  IHSecondLine
//
//  Created by iapp on 19/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//

import Foundation

extension UserDefaults {
    @UserDefault(key: "voip_token")
    static var voipToken: String?
    
    @UserDefault(key: "voip_token_data")
    static var voipTokenData: Data?
    
    @UserDefault(key: "country_code")
    static var countryCode: String?
    
    @UserDefault(key: "isd_code")
    static var isdCode: String?
}
