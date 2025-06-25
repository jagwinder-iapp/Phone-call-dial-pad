//
//  CountryModel.swift
//  IHSecondLine
//
//  Created by iapp on 19/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//

import Foundation

struct CountryModel: Codable {
    let name        : String?
    let code        : String?
    let dialCode    : String?
    
    init(name: String?, code: String?, dialCode: String? = nil) {
        self.name = name
        self.code = code
        self.dialCode = dialCode
    }
    
    enum CodingKeys: String, CodingKey {
        case name, code
        case dialCode = "dial_code"
    }
}
