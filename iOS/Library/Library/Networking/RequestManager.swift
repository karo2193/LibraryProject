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
    private let BOOK_ENDPOINT = "/ksiazka"
    private let CATEGORY_ENDPOINT = "/kategorie"
    private let DICTIONARY_ENDPOINT = "/slownik"
    
    typealias Filter = [String:Any]
    
    fileprivate func getRequest(usingHttpMethod httpMethod: String?, forEndpoint endpoint: String) -> URLRequest? {
        let address = URL_STRING + endpoint
        guard let url = URL(string: address) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
}

//MARK: Books fetch
extension RequestManager {
    
    func getBooks(withOffset offset: Int, completion: @escaping (([Book])->())) {
        let filter: Filter = getFilter(usingBook: SessionManager.shared.searchedBook)
        let categories = SessionManager.shared.searchedBook.getCategoriesId()
        let parameters = [
            "query" : [
                "filters" : filter,
                "kategorie" : categories,
                "pagination" : [
                    "offset" : offset,
                    "limit" : DefaultValues.BOOKS_PER_FETCH
                ]
            ]
        ]
        
        guard var request = getRequest(usingHttpMethod: "POST", forEndpoint: BOOK_ENDPOINT) else { return }
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog(error.localizedDescription)
            }
            guard let data = data else { return }
            do {
                let books = try JSONDecoder().decode([Book].self, from: data)
                completion(books)
            } catch let jsonError {
                NSLog(jsonError.localizedDescription)
                completion([])
            }
            }.resume()
    }
    
    fileprivate func getFilter(usingBook searchedBook: Book) -> Filter {
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
        if let mathSignature = searchedBook.mathLibrarySignature {
            filters["syg_ms__contains"] = mathSignature
        }
        if let mainSignature = searchedBook.mainLibrarySignature {
            filters["syg_bg__contains"] = mainSignature
        }
        if let year = searchedBook.year {
            filters["rok__contains"] = year
        }
        if let volume = searchedBook.volume {
            filters["tom__contains"] = volume
        }
        if let type = searchedBook.type {
            filters["typ__contains"] = type
        }
        if let availability = searchedBook.available {
            filters["dostepnosc__contains"] = availability
        }
        return filters
    }
    
}

//MARK: Categories fetch
extension RequestManager {
    
    func getCategories(completion: @escaping (([MainCategory])->())) {
        guard let request = getRequest(usingHttpMethod: "GET", forEndpoint: CATEGORY_ENDPOINT) else { return }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog(error.localizedDescription)
            }
            guard let data = data else { return }
            do {
                let mainCategories = try JSONDecoder().decode([MainCategory].self, from: data)
                completion(mainCategories)
            } catch let jsonError {
                NSLog(jsonError.localizedDescription)
                completion([])
            }
        }.resume()
    }
    
}

//MARK: Dictionary fetch
extension RequestManager {
    
    func getDictionary(completion: @escaping ((DictionaryTypes?)->())){
        guard let request = getRequest(usingHttpMethod: "GET", forEndpoint: DICTIONARY_ENDPOINT) else { return }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog(error.localizedDescription)
            }
            guard let data = data else { return }
            do {
                let dictionaryTypes = try JSONDecoder().decode(DictionaryTypes.self, from: data)
                completion(dictionaryTypes)
            } catch let jsonError {
                NSLog(jsonError.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
    
}
