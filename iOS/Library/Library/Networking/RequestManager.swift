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
    
    func getBooks(searchedBook: Book, completion: @escaping (([Book])->())) {
        let address = URL_STRING + BOOK_ENDPOINT
        guard let url = URL(string: address) else { return }
        
        let parameters = [
            "query" : [
                "filters" : [
                    "tytul__contains" : searchedBook.title ?? ""
                ],
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
        
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                NSLog(error.localizedDescription)
//            }
//            guard let data = data else { return }
//            print(data)
//            do {
//                let books = try JSONDecoder().decode([Book].self, from: data)
//                completion(books)
//                print(books.count)
//            } catch let jsonError {
//                NSLog(jsonError.localizedDescription)
//            }
//        }.resume()
    }
    
}
