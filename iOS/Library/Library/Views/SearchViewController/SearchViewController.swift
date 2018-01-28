//
//  SearchViewController.swift
//  Library
//
//  Created by Kryg Tomasz on 29.10.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class SearchViewController: MainVC {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.searchTextTableViewCell(), forCellReuseIdentifier: "SearchTextTableViewCell")
            tableView.register(R.nib.searchCategoryTableViewCell(), forCellReuseIdentifier: "SearchCategoryTableViewCell")
            tableView.dataSource = self
            tableView.delegate = self
            tableView.keyboardDismissMode = .interactive
            tableView.separatorStyle = .none
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: DefaultValues.EDGE_INSET_BOTTOM, right: 0)
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
    
    weak var delegate: MainPageViewControllerDelegate? {
        didSet {
            let leftButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(onLeftBarButtonClicked))
            let rightButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(onRightBarButtonClicked))
            delegate?.initNavigationBar(withTitle: R.string.localizable.bookSearch(), leftButton: leftButtonItem, rightButton: rightButtonItem)
        }
    }
    let searchTitles: [String] = [R.string.localizable.title(), R.string.localizable.author(), R.string.localizable.publicationYear(), R.string.localizable.bookVolume(), R.string.localizable.availability(), R.string.localizable.positionType(), R.string.localizable.isbn(), R.string.localizable.mathLibrarySignature(), R.string.localizable.mainLibrarySignature(), R.string.localizable.category()]
    let NUMBER_OF_ROWS: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor(to: .main)
        initObservers()
        tryGetAllFromServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchButton.isUserInteractionEnabled = true
    }
    
    func tryGetAllFromServices() {
        if tryShowNetworkAlert() {
            return
        }
        RequestManager.shared.getData(categoryCompletion: fillCategories, dictionaryCompletion: fillDictionary, completion: dataDownloadCompleted)
//        RequestManager.shared.getCategories(completion: fillCategories)
//        RequestManager.shared.getDictionary(completion: fillDictionary)
    }
    
    @objc func onLeftBarButtonClicked() {
        tryGetAllFromServices()
    }
    
    @objc func onRightBarButtonClicked() {
        SessionManager.shared.searchedBook.clear()
        self.tableView.reloadData()
    }
    
    @objc func onSearchButtonClicked() {
        if Reachability.isConnectedToNetwork() {
            searchButton.showIndicator()
            searchButton.isUserInteractionEnabled = false
            RequestManager.shared.getBooks(withOffset: 0, completion: goToListViewController)
        }
    }
    
    private func initObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func tryShowNetworkAlert() -> Bool {
        if !Reachability.isConnectedToNetwork() {
            showNetworkAlert()
            return true
        }
        return false
    }
    
    private func showNetworkAlert() {
        let alert = UIAlertController(title: R.string.localizable.connectionError(), message: R.string.localizable.checkInternetConnection(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: R.string.localizable.ok(), style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func fillCategories(using mainCategoriesArray: [MainCategory]) {
        SessionManager.shared.mainCategories = mainCategoriesArray
    }
    
    private func fillDictionary(using dictionaryTypes: DictionaryTypes?) {
        guard let dictionary = dictionaryTypes else { return }
        SessionManager.shared.dictionaryTypes = dictionary
    }
    
    private func dataDownloadCompleted() {
        
    }
    
    private func goToListViewController(with books: [Book]) {
        searchButton.hideIndicator()
        guard let listVC = R.storyboard.main().instantiateViewController(withIdentifier: "BookListViewController") as? BookListViewController else { return }
        listVC.books = books
        listVC.delegate = self.delegate
        DispatchQueue.main.async {
            self.delegate?.next(viewController: listVC)
        }
    }
    
}

//MARK: UITableView delegates
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUMBER_OF_ROWS
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 9 {
            guard let searchCategoryCell = tableView.dequeueReusableCell(withIdentifier: "SearchCategoryTableViewCell") as? SearchCategoryTableViewCell else {
                return UITableViewCell()
            }
            return searchCategoryCell
        } else {
            guard let searchTextCell = tableView.dequeueReusableCell(withIdentifier: "SearchTextTableViewCell") as? SearchTextTableViewCell else {
                return UITableViewCell()
            }
            return searchTextCell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if let searchTextCell = cell as? SearchTextTableViewCell {
            searchTextCell.titleLabel.text = searchTitles[row]
            searchTextCell.delegate = self
            searchTextCell.row = indexPath.row
            searchTextCell.textField.text = getTextFromProperty(for: searchTextCell)
            return
        }
        if let searchCategoryCell = cell as? SearchCategoryTableViewCell {
            searchCategoryCell.delegate = self
            searchCategoryCell.refreshButtonTitle()
        }
    }
    
    private func getTextFromProperty(for cell: SearchTextTableViewCell) -> String? {
        let type = cell.searchPropertyType
        switch type {
        case .title:
            return SessionManager.shared.searchedBook.title
        case .author:
            return SessionManager.shared.searchedBook.authors
        case .isbn:
            return SessionManager.shared.searchedBook.isbn
        case .mathSignature:
            return SessionManager.shared.searchedBook.mathLibrarySignature
        case .mainSignature:
            return SessionManager.shared.searchedBook.mainLibrarySignature
        case .year:
            return SessionManager.shared.searchedBook.year
        case .volume:
            return SessionManager.shared.searchedBook.volume
        case .type:
            return SessionManager.shared.searchedBook.type
        case .category:
//            cell.textField.text = searchedBook.
            return ""
        case .availability:
            return SessionManager.shared.searchedBook.available
        default:
            return ""
        }
    }
    
}

//MARK: SearchTextTableViewCellDelegate
extension SearchViewController: SearchTextTableViewCellDelegate {
    
    func fill(text: String, forType type: SearchPropertyType) {
        switch type {
        case .title:
            SessionManager.shared.searchedBook.title = text
        case .author:
            SessionManager.shared.searchedBook.authors = text
        case .isbn:
            SessionManager.shared.searchedBook.isbn = text
        case .mathSignature:
            SessionManager.shared.searchedBook.mathLibrarySignature = text
        case .mainSignature:
            SessionManager.shared.searchedBook.mainLibrarySignature = text
        case .year:
            SessionManager.shared.searchedBook.year = text
        case .volume:
            SessionManager.shared.searchedBook.volume = text
        case .type:
            SessionManager.shared.searchedBook.type = text
        case .category:
            return
        case .availability:
            SessionManager.shared.searchedBook.available = text
        default:
            return
        }
    }
    
}

//MARK: SearchCategoryTableViewCellDelegate
extension SearchViewController: SearchCategoryTableViewCellDelegate {
    
    func showCategoriesViewController() {
        guard let categoriesVC = R.storyboard.main().instantiateViewController(withIdentifier: "CategoriesViewController") as? CategoriesViewController else { return }
        categoriesVC.delegate = self.delegate
        DispatchQueue.main.async {
            self.delegate?.next(viewController: categoriesVC)
        }
    }
    
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
        tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, DefaultValues.EDGE_INSET_BOTTOM, 0.0)
    }
    
}
