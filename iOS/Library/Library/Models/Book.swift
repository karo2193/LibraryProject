//
//  Book.swift
//  Library
//
//  Created by Kryg Tomasz on 23.11.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import Foundation

struct Book: Codable {
    
    private var title: String?
    private var responsibility: String?
    private var isbn_issn: String?
    private var signature_ms: Int?
    private var signature_bg: String?
    private var year: Int?
    private var volume: String?
    private var type: String?
    private var availability: String?
    private var categories: [Category] = []
    
    var bookTitle: String? {
        set {
            title = newValue
        }
        get {
            return title
        }
    }
    
    var bookAuthors: String? {
        set {
            responsibility = newValue
        }
        get {
            return responsibility
        }
    }
    
    var bookIsbn: String? {
        set {
            isbn_issn = newValue
        }
        get {
            return isbn_issn
        }
    }
    
    var bookMathLibrarySignature: String? {
        set {
            let mathSignatureString = newValue ?? ""
            let mathSignatureValue = Int(mathSignatureString)
            signature_ms = mathSignatureValue
        }
        get {
            if let mathSignatureValue = signature_ms {
                return "\(mathSignatureValue)"
            } else {
                return nil
            }
        }
    }
    
    var bookMainLibrarySignature: String? {
        set {
            signature_bg = newValue
        }
        get {
            return signature_bg
        }
    }
    
    var bookYear: String? {
        set {
            let yearString = newValue ?? ""
            let yearValue = Int(yearString)
            year = yearValue
        }
        get {
            if let yearValue = year {
                return "\(yearValue)"
            } else {
                return nil
            }
        }
    }
    
    var bookVolume: String? {
        set {
            volume = newValue
        }
        get {
            return volume
        }
    }
    
    var bookType: String? {
        set {
            type = newValue
        }
        get {
            return type
        }
    }
    
    var bookAvailable: String? {
        set {
            availability = newValue
        }
        get {
            return availability
        }
    }
    
    var bookCategories: [Category] {
        set {
            categories = newValue
        }
        get {
            return categories
        }
    }
    
    mutating func clear() {
        self.bookTitle = nil
        self.bookAuthors = nil
        self.bookIsbn = nil
        self.bookMathLibrarySignature = nil
        self.bookMainLibrarySignature = nil
        self.bookYear = nil
        self.bookVolume = nil
        self.bookType = nil
        self.bookAvailable = nil
        self.bookCategories = []
    }
    
    func getCategoriesId() -> [String] {
        let categoriesObject = bookCategories
        let categoriesId: [String] = categoriesObject.map {$0.id ?? ""}
        return categoriesId
    }
    
}
