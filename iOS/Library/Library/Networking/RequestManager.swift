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
    
    private let URL_STRING = "http://157.158.16.217:8000/"
    private let BOOK_ENDPOINT = "books"
    private let CATEGORY_ENDPOINT = "categories"
    private let DICTIONARY_ENDPOINT = "dictionary"
    
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
                "categories" : categories,
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
        if let title = searchedBook.bookTitle {
            filters["title__contains"] = title.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let author = searchedBook.bookAuthors {
            filters["responsibility__contains"] = author.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let isbn = searchedBook.bookIsbn {
            let isbnText = isbn.trimmingCharacters(in: .whitespacesAndNewlines)
            var value = ""
            let digits = NSCharacterSet.decimalDigits
            for char in isbnText.unicodeScalars {
                if digits.contains(char) {
                    value += String(char)
                }
            }
            filters["isbn_issn"] = value
        }
        if let mathSignature = searchedBook.bookMathLibrarySignature {
            filters["signature_ms"] = mathSignature.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let mainSignature = searchedBook.bookMainLibrarySignature {
            filters["signature_bg__contains"] = mainSignature.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let year = searchedBook.bookYear {
            filters["year"] = year.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let volume = searchedBook.bookVolume {
            filters["volume__contains"] = volume.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let type = searchedBook.bookType {
            filters["type__contains"] = type.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let availability = searchedBook.bookAvailable {
            filters["availability__contains"] = availability.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return filters
    }
    
}

//MARK: Needed data fetch (categories + dictionary)
extension RequestManager {
    
    func getData(categoryCompletion: @escaping (([MainCategory])->()), dictionaryCompletion: @escaping ((DictionaryTypes?)->()), completion: @escaping (()->())) {
        let downloadGroup = DispatchGroup()
        downloadGroup.enter()
        getCategories() {
            mainCategories in
            categoryCompletion(mainCategories)
            downloadGroup.leave()
        }
        downloadGroup.enter()
        getDictionary() {
            dictionaryTypes in
            dictionaryCompletion(dictionaryTypes)
            downloadGroup.leave()
        }
        downloadGroup.notify(queue: .main) {
            completion()
        }
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
