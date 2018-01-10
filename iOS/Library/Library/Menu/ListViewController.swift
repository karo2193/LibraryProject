//
//  ListViewController.swift
//  Library
//
//  Created by Kryg Tomasz on 23.11.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class ListViewController: MainVC {

    @IBOutlet weak var titleView: UIView! {
        didSet {
            titleView.backgroundColor = .main
            titleView.addShadow()
        }
    }
    @IBOutlet weak var viewTitleLabel: UILabel! {
        didSet {
            viewTitleLabel.textColor = .tintDark
            viewTitleLabel.text = R.string.localizable.searchingResults()
        }
    }
    @IBOutlet weak var titleSeparatorView: UIView! {
        didSet {
            titleSeparatorView.backgroundColor = .tintDark
        }
    }
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
    
    var books: [Book] = [] {
        didSet {
            self.view.layoutIfNeeded()
            reloadView()
        }
    }
    
    weak var delegate: MainPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor(to: .main)
        tableView.separatorColor = .tintDark
        addParallaxEffect()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
        }
    }
    
    private func addParallaxEffect() {
        backButton.addParallaxEffect(20)
    }
    
    private func reloadView() {
        tableView.reloadData()
        let topIndexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: topIndexPath, at: .top, animated: false)
    }
    
    @objc func onButtonClicked() {
        delegate?.previousViewController(from: self)
    }

}

//MARK: TableView delegates
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
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

//MARK: 3D Touch delegate
extension ListViewController: UIViewControllerPreviewingDelegate {
    
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
