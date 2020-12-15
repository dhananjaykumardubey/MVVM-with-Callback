//
//  UserDefaults+Wrapper.swift
//  PayPay-Code-Challenge
//
//  Created by Dhananjay Kumar Dubey on 15/12/20.
//  Copyright © 2020 Dhananjay. All rights reserved.
//

import Foundation

final class UserDefaultsHelper {
    
    static func set(_ value: RateLists?, forKey defaultName: String) {
        guard let data = try? PropertyListEncoder().encode(value)
            else {
                return
        }
        UserDefaults.standard.set(data, forKey: defaultName)
    }
    
    static func get(forKey defaultName: String) -> RateLists? {
        guard let data = UserDefaults.standard.object(forKey: defaultName) as? Data
            else { return nil }
        return try? PropertyListDecoder().decode(RateLists.self, from: data)
    }
    
    static func removeData(key: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
    }
    
    static func removeAll() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}
