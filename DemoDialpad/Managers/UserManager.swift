//
//  UserDetails.swift
//  DemoDialpad
//
//  Created by iapp on 18/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//

class UserManager {
    static let shared = UserManager()
    
    private init() {}
    
    func hasBoughtPhoneNumber() -> Bool {
        return !getPhoneNumber().isEmpty
    }
    
    func getPhoneNumber() -> String {
        return ""
    }
    
    func hasUserBoughtTelnyxNumber() -> Bool {
        return true
    }
    
    func getUsername() -> String {
        return ""
    }
    
    func getPassword() -> String {
        return ""
    }
    
    func getAccessToken() -> String {
        return ""
    }
}
