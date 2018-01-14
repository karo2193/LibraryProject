//
//  RequestManager.swift
//  Library
//
//  Created by Kryg Tomasz on 07.01.2018.
//  Copyright © 2018 Kryg Tomek. All rights reserved.
//

import Foundation

class RequestManager {
    
    private init() { }
    
    static let shared = RequestManager()
    
    private let URL_STRING = "http://szymongor.pythonanywhere.com"
    private let BOOK_ENDPOINT = "/ksiazka/"
    
    typealias Filter = [String:Any]
    
    func getBooks(searchedBook: Book, completion: @escaping (([Book])->())) {
        let address = URL_STRING + BOOK_ENDPOINT
        guard let url = URL(string: address) else { return }
        
        let filter: Filter = getFilter(usingBook: searchedBook)
        
        let parameters = [
            "query" : [
                "filters" : filter,
                "pagination" : [
                    "offset" : 0,
                    "limit" : 100
                ]
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog(error.localizedDescription)
            }
            guard let data = data else { return }
            print(data)
            do {
                let books = try JSONDecoder().decode([Book].self, from: data)
                completion(books)
                print(books.count)
            } catch let jsonError {
                NSLog(jsonError.localizedDescription)
                completion([])
            }
        }.resume()
    }
    
    private func getFilter(usingBook searchedBook: Book) -> Filter {
        var filters: Filter = [:]
        if let title = searchedBook.title {
            filters["tytul__contains"] = title
        }
        if let author = searchedBook.authors {
            filters["ozn_opdow__contains"] = author
        }
        if let isbn = searchedBook.isbn {
            filters["isbn_issn__contains"] = isbn
        }
        if let signature = searchedBook.mainLibrarySignature {
            filters["syg_bg__contains"] = signature
        }
        if let year = searchedBook.year {
            filters["rok__contains"] = year
        }
        if let volume = searchedBook.volume {
            filters["tom__contains"] = volume
        }
        return filters
    }
    
}
