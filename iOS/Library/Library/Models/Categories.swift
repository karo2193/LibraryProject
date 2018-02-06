//
//  Category.swift
//  Library
//
//  Created by Kryg Tomasz on 17.01.2018.
//  Copyright © 2018 Kryg Tomek. All rights reserved.
//

import Foundation

struct MainCategory: Decodable {
    
    private var main_category: Category?
    private var subcategories: [Category]
    
    var category: Category? {
        get {
            return main_category
        }
        set {
            main_category = newValue
        }
    }
    
    var subcategoriesArray: [Category] {
        get {
            return subcategories
        }
        set {
            subcategories = newValue
        }
    }
    
}

struct Category: Codable {
    
    private var category_id: String?
    private var category_name: String?
    
    var id: String? {
        get {
            return category_id
        }
        set {
            category_id = newValue
        }
    }
    
    var name: String? {
        get {
            return category_name
        }
        set {
            category_name = newValue
        }
    }
    
}
