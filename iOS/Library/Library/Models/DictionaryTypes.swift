//
//  DictionaryTypes.swift
//  Library
//
//  Created by Kryg Tomasz on 17.01.2018.
//  Copyright © 2018 Kryg Tomek. All rights reserved.
//

import Foundation

struct DictionaryTypes: Codable {
    
    private var types: [String] = []
    private var availability_types: [String] = []
    
    var type: [String] {
        get {
            let dictTypes = [""] + types
            return dictTypes
        }
        set {
            types = newValue
        }
    }
    
    var availability: [String] {
        get {
            let availables = [""] + availability_types
            return availables
        }
        set {
            availability_types = newValue
        }
    }

}
