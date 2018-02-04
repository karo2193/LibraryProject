//
//  BookListViewController.swift
//  Library
//
//  Created by Kryg Tomasz on 23.11.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit
import UIEmptyState
import JGProgressHUD

protocol HudDelegate: class {
    func showHud(_ title: String)
}

class BookListViewController: MainVC {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.bookTableViewCell(), forCellReuseIdentifier: "BookTableViewCell")
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    var hud: JGProgressHUD? = nil
    private var offset: Int = 0
    private var canFetchMore: Bool = true
    weak var delegate: MainPageViewControllerDelegate? {
        didSet {
            let leftButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back").scale(toWidth: 24, height: 24), style: .plain, target: self, action: #selector(onBackButtonClicked))
            delegate?.initNavigationBar(withTitle: R.string.localizable.searchingResults(), leftButton: leftButtonItem, rightButton: nil)
        }
    }
    var books: [Book] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view.layoutIfNeeded()
                self.tableView.reloadData()
                if self.books.isEmpty {
                    self.tableView.isHidden = true
                } else {
                    self.tableView.isHidden = false
                }
                self.reloadEmptyStateForTableView(self.tableView)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEmptyStateDelegates()
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
    
    @objc func onBackButtonClicked() {
        guard let searchVC = R.storyboard.main().instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else { return }
        searchVC.delegate = self.delegate
        delegate?.previous(viewController: searchVC)
    }

}

//MARK: UITableView delegates
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
        let detailsVC = getBookDetailsViewController(forBook: book)
        let navController = UINavigationController(rootViewController: detailsVC)
        present(navController, animated: true, completion: nil)
    }
    
    private func getBookDetailsViewController(forBook book: Book) -> UIViewController {
        guard let detailsVC = R.storyboard.main().instantiateViewController(withIdentifier: "BookDetailsViewController") as? BookDetailsViewController else { return UIViewController() }
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

//MARK: HudDelegate
extension BookListViewController: HudDelegate {
    
    func showHud(_ title: String) {
        DispatchQueue.main.async {
            self.hud = JGProgressHUD(style: .dark)
            self.hud?.textLabel.text = title
            self.hud?.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.hud?.show(in: self.view)
            self.hud?.dismiss(afterDelay: 0.75)
        }
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
        let detailsVC = getBookDetailsViewController(forBook: book)
        if let detailsViewController = detailsVC as? BookDetailsViewController {
            detailsViewController.hudDelegate = self
        }
        previewingContext.sourceRect = cell.frame
        return detailsVC
    }
    
    //POP
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewControllerToCommit)
        self.showDetailViewController(navigationController, sender: self)
    }
    
}

//MARK: UIEmptyState delegates
extension BookListViewController: UIEmptyStateDelegate, UIEmptyStateDataSource {
    
    fileprivate func setEmptyStateDelegates() {
        self.emptyStateDelegate = self
        self.emptyStateDataSource = self
    }
    
    var emptyStateBackgroundColor: UIColor {
        return .main
    }
    
    var emptyStateTitle: NSAttributedString {
        let title = R.string.localizable.noResults()
        let range = (title as NSString).range(of: title)
        let titleAttributedString = NSMutableAttributedString(string: title)
        let titleColor = UIColor.tintDark
        titleAttributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: titleColor, range: range)
        return titleAttributedString
    }
    
    var emptyStateImage: UIImage? {
        let image = #imageLiteral(resourceName: "books").maskWithColor(color: .tintDark)
        return image
    }
    
}
