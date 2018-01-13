//
//  Book.swift
//  Library
//
//  Created by Kryg Tomasz on 23.11.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import Foundation

struct Book: Codable {
    
    private var tytul: String?
    private var ozn_opdow: String?
    private var rok: Int?
    
    var title: String? {
        set {
            tytul = title
        }
        get {
            return tytul
        }
    }
    
    var authors: String? {
        set {
            ozn_opdow = authors
        }
        get {
            return ozn_opdow
        }
    }
    
    var year: Int? {
        set {
            rok = year
        }
        get {
            return rok
        }
    }
    
}
