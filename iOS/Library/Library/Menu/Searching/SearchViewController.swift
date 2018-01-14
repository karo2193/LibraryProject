//
//  SearchViewController.swift
//  Library
//
//  Created by Kryg Tomasz on 29.10.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class SearchViewController: MainVC {

    @IBOutlet weak var titleView: UIView! {
        didSet {
            titleView.backgroundColor = .main
            titleView.addShadow()
        }
    }
    @IBOutlet weak var viewTitleLabel: UILabel! {
        didSet {
            viewTitleLabel.textColor = .tintDark
            viewTitleLabel.text = R.string.localizable.bookSearch()
            
        }
    }
    @IBOutlet weak var titleSeparatorView: UIView! {
        didSet {
            titleSeparatorView.backgroundColor = .tintDark
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.searchTextTableViewCell(), forCellReuseIdentifier: "SearchTextTableViewCell")
            tableView.dataSource = self
            tableView.delegate = self
            tableView.keyboardDismissMode = .interactive
            tableView.separatorStyle = .none
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 72, right: 0)
        }
    }
    @IBOutlet weak var searchButton: LoadingButton! {
        didSet {
            searchButton.appTheme()
            searchButton.setTitle(R.string.localizable.search(), for: .normal)
            searchButton.addTarget(self, action: #selector(onSearchButtonClicked), for: .touchUpInside)
            searchButton.addShadow()
        }
    }
    
    weak var delegate: MainPageViewControllerDelegate?
    let searchTitles: [String] = [R.string.localizable.title(), R.string.localizable.author(), R.string.localizable.isbn(), R.string.localizable.mainLibrarySignature(), R.string.localizable.publicationYear(), R.string.localizable.bookVolume(), R.string.localizable.positionType(), R.string.localizable.category()]
    let NUMBER_OF_ROWS: Int = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor(to: .main)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchButton.isUserInteractionEnabled = true
    }
    
    func tryGetTextToSearch(fromIndexPath indexPath: IndexPath) -> String? {
        var value: String?
        if
            let searchTextCell = tableView.cellForRow(at: indexPath) as? SearchTextTableViewCell,
            let searchedValue = searchTextCell.textField.text {
            if !searchedValue.isEmpty {
                value = searchedValue.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        return value
    }
    
    private func getBookForSearch() -> Book {
        var searchedBook = Book()
        
        let titleIndexPath = IndexPath(row: 0, section: 0)
        let title = tryGetTextToSearch(fromIndexPath: titleIndexPath)
        searchedBook.title = title
        
        let authorIndexPath = IndexPath(row: 1, section: 0)
        let author = tryGetTextToSearch(fromIndexPath: authorIndexPath)
        searchedBook.authors = author
        
        let isbnIndexPath = IndexPath(row: 2, section: 0)
        let isbn = tryGetTextToSearch(fromIndexPath: isbnIndexPath)
        searchedBook.isbn = isbn
        
        let signtureIndexPath = IndexPath(row: 3, section: 0)
        let mainSignature = tryGetTextToSearch(fromIndexPath: signtureIndexPath)
        searchedBook.mainLibrarySignature = mainSignature
        
        let yearIndexPath = IndexPath(row: 4, section: 0)
        let year = tryGetTextToSearch(fromIndexPath: yearIndexPath)
        searchedBook.year = year
        
        let volumeIndexPath = IndexPath(row: 5, section: 0)
        let volume = tryGetTextToSearch(fromIndexPath: volumeIndexPath)
        searchedBook.volume = volume
        
        return searchedBook
    }
    
    @objc func onSearchButtonClicked() {
        searchButton.showIndicator()
        searchButton.isUserInteractionEnabled = false
        
        let searchedBook = getBookForSearch()
        
        RequestManager.shared.getBooks(searchedBook: searchedBook,completion: goToListViewController)
    }
    
    func goToListViewController(with books: [Book]) {
        searchButton.hideIndicator()
        DispatchQueue.main.async {
            self.delegate?.nextViewController(from: self, books: books)
        }
    }
    
}

//MARK: TableView delegates
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUMBER_OF_ROWS
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let searchTextCell = tableView.dequeueReusableCell(withIdentifier: "SearchTextTableViewCell") as? SearchTextTableViewCell else {
            return UITableViewCell()
        }
        return searchTextCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if let searchTextCell = cell as? SearchTextTableViewCell {
            searchTextCell.titleLabel.text = searchTitles[row]
            return
        }
        if let searchButtonCell = cell as? SearchTextTableViewCell {
            return
        }
    }
    
}
