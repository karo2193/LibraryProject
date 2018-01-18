//
//  BookListViewController.swift
//  Library
//
//  Created by Kryg Tomasz on 23.11.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class BookListViewController: MainVC {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.bookTableViewCell(), forCellReuseIdentifier: "BookTableViewCell")
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 72, right: 0)
        }
    }
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.appTheme()
            backButton.setTitle(R.string.localizable.backToSearch(), for: .normal)
            backButton.addTarget(self, action: #selector(onButtonClicked), for: .touchUpInside)
            backButton.addShadow()
        }
    }
    
    private var offset: Int = 0
    private var canFetchMore: Bool = true
    weak var delegate: MainPageViewControllerDelegate? {
        didSet {
            delegate?.initNavigationBar(withTitle: R.string.localizable.searchingResults())
        }
    }
    var books: [Book] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view.layoutIfNeeded()
                self.tableView.reloadData()
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor(to: .main)
        tableView.separatorColor = .tintDark
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
        }
    }
    
    private func reloadView() {
        tableView.reloadData()
        scrollTableViewToTop()
    }
    
    private func scrollTableViewToTop() {
        if !books.isEmpty {
            let topIndexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: topIndexPath, at: .top, animated: false)
        }
    }
    
    @objc func onButtonClicked() {
        guard let searchVC = R.storyboard.main().instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else { return }
        searchVC.delegate = self.delegate
        delegate?.previous(viewController: searchVC)
    }

}

//MARK: TableView delegates
extension BookListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let bookCell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell") as? BookTableViewCell else {
            return UITableViewCell()
        }
        return bookCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let bookCell = cell as? BookTableViewCell else {
            return
        }
        let book = books[indexPath.row]
        bookCell.fill(using: book)
        tryFetchMoreBooks(loadedIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? BookTableViewCell else {
            return
        }
        selectedCell.setSelected(false, animated: true)
        let book = books[indexPath.row]
        let detailsVC = getDetailsViewController(withBook: book)
        present(detailsVC, animated: true, completion: nil)
    }
    
    private func getDetailsViewController(withBook book: Book) -> UIViewController {
        guard let detailsVC = R.storyboard.main().instantiateViewController(withIdentifier: "BookCoverViewController") as? BookCoverViewController else { return UIViewController() }
        detailsVC.book = book
        return detailsVC
    }
    
}

//MARK: Fetch more books methods
extension BookListViewController {
    
    fileprivate func tryFetchMoreBooks(loadedIndexPath: IndexPath) {
        let rowWhenFetchNeeded = books.count - 5
        if loadedIndexPath.row == rowWhenFetchNeeded && canFetchMore {
            offset += DefaultValues.BOOKS_PER_FETCH
            RequestManager.shared.getBooks(withOffset: offset, completion: appendFetchedBooks)
        }
    }
    
    fileprivate func appendFetchedBooks(_ fetchedBooks: [Book]) {
        if fetchedBooks.isEmpty {
            canFetchMore = false
            return
        }
        self.books.append(contentsOf: fetchedBooks)
    }
    
}

//MARK: 3D Touch delegate
extension BookListViewController: UIViewControllerPreviewingDelegate {
    
    //PEEK
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else {
                return nil
        }
        let book = books[indexPath.row]
        let detailsVC = getDetailsViewController(withBook: book)
        previewingContext.sourceRect = cell.frame
        return detailsVC
    }
    
    //POP
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.showDetailViewController(viewControllerToCommit, sender: self)
    }
    
}
