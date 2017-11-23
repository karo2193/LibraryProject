//
//  Book.swift
//  Library
//
//  Created by Kryg Tomasz on 23.11.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import Foundation

class Book {
    
    var title: String?
    var author: String?
    var year: Int?
    
    init(title: String?, author: String?, year: Int?) {
        self.title = title
        self.author = author
        self.year = year
    }
    
}
