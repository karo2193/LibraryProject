//
//  DictionaryTypes.swift
//  Library
//
//  Created by Kryg Tomasz on 17.01.2018.
//  Copyright © 2018 Kryg Tomek. All rights reserved.
//

import Foundation

struct DictionaryTypes: Codable {
    
    private var typ: [String] = []
    private var dostepnosc: [String] = []
    
    var type: [String] {
        get {
            return typ
        }
        set {
            typ = newValue
        }
    }
    
    var availability: [String] {
        get {
            return dostepnosc
        }
        set {
            dostepnosc = newValue
        }
    }

}
