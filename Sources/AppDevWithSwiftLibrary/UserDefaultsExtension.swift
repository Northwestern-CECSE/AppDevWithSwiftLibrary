//
//  File.swift
//  
//
//  Created by Kevin McQuown on 4/23/21.
//

import Foundation

extension UserDefaults {
    func setStructValue<T: Codable> (value: T, forKey: String) {
        let result = String(data: try! JSONEncoder().encode(value), encoding: .utf8)!
        UserDefaults.standard.setValue(result, forKey: forKey)
    }
    
    func getStructValue<T: Codable>(forKey: String) -> T? {
        if let fromDict = UserDefaults.standard.string(forKey: forKey) {
            let result = try! JSONDecoder().decode(T.self, from: fromDict.data(using: .utf8)!)
            return result
        }
        return nil
    }
}
