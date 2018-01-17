//
//  Category.swift
//  Library
//
//  Created by Kryg Tomasz on 17.01.2018.
//  Copyright © 2018 Kryg Tomek. All rights reserved.
//

import Foundation

struct MainCategory: Decodable {
    
    private var kategoria: Category?
    private var podkategorie: [Category]
    
    var category: Category? {
        get {
            return kategoria
        }
        set {
            kategoria = newValue
        }
    }
    
    var subcategories: [Category] {
        get {
            return podkategorie
        }
        set {
            podkategorie = newValue
        }
    }
    
}

struct Category: Codable {
    
    private var id_kategorii: String?
    private var kategoria: String?
    
    var id: String? {
        get {
            return id_kategorii
        }
        set {
            id_kategorii = newValue
        }
    }
    
    var name: String? {
        get {
            return kategoria
        }
        set {
            kategoria = newValue
        }
    }
    
}
