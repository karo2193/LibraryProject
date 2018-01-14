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
    private var isbn_issn: String?
    private var syg_bg: String?
    private var rok: Int?
    private var tom: String?
    private var typ: String?
    
    var title: String? {
        set {
            tytul = newValue
        }
        get {
            return tytul
        }
    }
    
    var authors: String? {
        set {
            ozn_opdow = newValue
        }
        get {
            return ozn_opdow
        }
    }
    
    var isbn: String? {
        set {
            isbn_issn = newValue
        }
        get {
            return isbn_issn
        }
    }
    
    var mainLibrarySignature: String? {
        set {
            syg_bg = newValue
        }
        get {
            return syg_bg
        }
    }
    
    var year: String? {
        set {
            let yearString = newValue ?? ""
            let yearValue = Int(yearString)
            rok = yearValue
        }
        get {
            if let yearValue = rok {
                return "\(yearValue)"
            } else {
                return nil
            }
        }
    }
    
    var volume: String? {
        set {
            tom = newValue
        }
        get {
            return tom
        }
    }
    
    var type: String? {
        set {
            typ = newValue
        }
        get {
            return typ
        }
    }
    
}
