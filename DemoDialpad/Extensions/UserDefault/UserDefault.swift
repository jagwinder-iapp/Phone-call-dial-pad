//
//  UserDefault.swift
//  IHSecondLine
//
//  Created by iapp on 19/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//


import Foundation

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    var container: UserDefaults = .standard
    
    var wrappedValue: Value? {
        get {
            if let decodableType = Value.self as? Decodable.Type,
               let data = container.data(forKey: key) {
                do {
                    let data = try JSONDecoder().decode(decodableType, from: data)
                    return data as? Value
                } catch {
                    print("error in \(#function)", error.localizedDescription)
                }
            } else {
                return container.object(forKey: key) as? Value
            }
            return nil
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}
