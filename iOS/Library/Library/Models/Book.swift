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
    private var syg_ms: Int?
    private var syg_bg: String?
    private var rok: Int?
    private var tom: String?
    private var typ: String?
    private var dostepnosc: String?
    private var kategoria: [Category] = []
    
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
    
    var mathLibrarySignature: String? {
        set {
            let mathSignatureString = newValue ?? ""
            let mathSignatureValue = Int(mathSignatureString)
            syg_ms = mathSignatureValue
        }
        get {
            if let mathSignatureValue = syg_ms {
                return "\(mathSignatureValue)"
            } else {
                return nil
            }
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
    
    var available: String? {
        set {
            dostepnosc = newValue
        }
        get {
            return dostepnosc
        }
    }
    
    var categories: [Category] {
        set {
            kategoria = newValue
        }
        get {
            return kategoria
        }
    }
    
    mutating func clear() {
        self.title = ""
        self.authors = ""
        self.isbn = ""
        self.mathLibrarySignature = ""
        self.mainLibrarySignature = ""
        self.year = ""
        self.volume = ""
        self.type = ""
        self.available = ""
        self.categories = []
    }
    
    func getCategoriesId() -> [String] {
        let categoriesObject = categories
        let categoriesId: [String] = categoriesObject.map {$0.id ?? ""}
        return categoriesId
    }
    
}
