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
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: EDGE_INSET_BOTTOM, right: 0)
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
    let searchTitles: [String] = [R.string.localizable.title(), R.string.localizable.author(), R.string.localizable.isbn(), R.string.localizable.mathLibrarySignature(), R.string.localizable.mainLibrarySignature(), R.string.localizable.publicationYear(), R.string.localizable.bookVolume(), R.string.localizable.positionType(), R.string.localizable.category(), R.string.localizable.availability()]
    let NUMBER_OF_ROWS: Int = 10
    let EDGE_INSET_BOTTOM: CGFloat = 72.0
    
    var searchedBook: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor(to: .main)
        initObservers()
        searchedBook = Book()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchButton.isUserInteractionEnabled = true
    }
    
    private func initObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
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

//MARK: Book searching methods
extension SearchViewController {
    
    fileprivate func getBookForSearch() -> Book {
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
        
        let mathSignatureIndexPath = IndexPath(row: 3, section: 0)
        let mathSignature = tryGetTextToSearch(fromIndexPath: mathSignatureIndexPath)
        searchedBook.mathLibrarySignature = mathSignature
        
        let mainSignatureIndexPath = IndexPath(row: 4, section: 0)
        let mainSignature = tryGetTextToSearch(fromIndexPath: mainSignatureIndexPath)
        searchedBook.mainLibrarySignature = mainSignature
        
        let yearIndexPath = IndexPath(row: 5, section: 0)
        let year = tryGetTextToSearch(fromIndexPath: yearIndexPath)
        searchedBook.year = year
        
        let volumeIndexPath = IndexPath(row: 6, section: 0)
        let volume = tryGetTextToSearch(fromIndexPath: volumeIndexPath)
        searchedBook.volume = volume
        
        let typeIndexPath = IndexPath(row: 7, section: 0)
        let type = tryGetTextToSearch(fromIndexPath: typeIndexPath)
        searchedBook.type = type
        
        let availabilityIndexPath = IndexPath(row: 9, section: 0)
        let available = tryGetTextToSearch(fromIndexPath: availabilityIndexPath)
        searchedBook.available = available
        
        return searchedBook
    }
    
    private func tryGetTextToSearch(fromIndexPath indexPath: IndexPath) -> String? {
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
//            searchTextCell.textField.text = getTextFromProperty(fromIndexPath: indexPath)
            return
        }
        if let searchButtonCell = cell as? SearchTextTableViewCell {
            return
        }
    }
    
//    private func getTextFromProperty(fromIndexPath indexPath: IndexPath) -> String? {
//        let row = indexPath.row
//        switch row {
//        case 0:
//            return
//        default:
//            <#code#>
//        }
//        let titleIndexPath = IndexPath(row: 0, section: 0)
//        let title = tryGetTextToSearch(fromIndexPath: titleIndexPath)
//        searchedBook.title = title
//
//        let authorIndexPath = IndexPath(row: 1, section: 0)
//        let author = tryGetTextToSearch(fromIndexPath: authorIndexPath)
//        searchedBook.authors = author
//
//        let isbnIndexPath = IndexPath(row: 2, section: 0)
//        let isbn = tryGetTextToSearch(fromIndexPath: isbnIndexPath)
//        searchedBook.isbn = isbn
//
//        let mathSignatureIndexPath = IndexPath(row: 3, section: 0)
//        let mathSignature = tryGetTextToSearch(fromIndexPath: mathSignatureIndexPath)
//        searchedBook.mathLibrarySignature = mathSignature
//
//        let mainSignatureIndexPath = IndexPath(row: 4, section: 0)
//        let mainSignature = tryGetTextToSearch(fromIndexPath: mainSignatureIndexPath)
//        searchedBook.mainLibrarySignature = mainSignature
//
//        let yearIndexPath = IndexPath(row: 5, section: 0)
//        let year = tryGetTextToSearch(fromIndexPath: yearIndexPath)
//        searchedBook.year = year
//
//        let volumeIndexPath = IndexPath(row: 6, section: 0)
//        let volume = tryGetTextToSearch(fromIndexPath: volumeIndexPath)
//        searchedBook.volume = volume
//
//        let typeIndexPath = IndexPath(row: 7, section: 0)
//        let type = tryGetTextToSearch(fromIndexPath: typeIndexPath)
//        searchedBook.type = type
//
//        let availabilityIndexPath = IndexPath(row: 9, section: 0)
//        let available = tryGetTextToSearch(fromIndexPath: availabilityIndexPath)
//        searchedBook.available = available
//    }
    
}

//MARK: Keyboard handling
extension SearchViewController {
    
    @objc func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.size.height + 8.0, 0.0)
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, EDGE_INSET_BOTTOM, 0.0)
    }
    
}
