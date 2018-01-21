//
//  BookDetailsViewController.swift
//  Library
//
//  Created by Kryg Tomasz on 21.01.2018.
//  Copyright © 2018 Kryg Tomek. All rights reserved.
//

import UIKit

class BookDetailsViewController: MainVC {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.bookDetailTableViewCell(), forCellReuseIdentifier: "BookDetailTableViewCell")
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 100
        }
    }
    
    var book: Book?
    
    override var previewActionItems: [UIPreviewActionItem] {
        let copyTitleAction = UIPreviewAction(title: R.string.localizable.copyTitle(), style: .default) { (action, vc) in
            UIPasteboard.general.string = self.book?.title
        }
        let copyAuthorAction = UIPreviewAction(title: R.string.localizable.copyAuthor(), style: .default) { (action, viewcontroller) in
            UIPasteboard.general.string = self.book?.authors
        }
        let copyGroupAction = UIPreviewActionGroup(title: R.string.localizable.copy() + "...", style: .default, actions: [copyTitleAction, copyAuthorAction])
        return [copyGroupAction]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor(to: .main)
        initNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.beginUpdates()
        tableView.endUpdates()
        initNavigationBar()
    }
    
    private func initNavigationBar() {
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barStyle = .blackOpaque
        navigationBar?.barTintColor = .tintDark
        navigationBar?.tintColor = .main
        navigationBar?.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.main]
        navigationBar?.topItem?.title = R.string.localizable.bookDetails()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "expand").scale(toWidth: 24, height: 24), style: .plain, target: self, action: #selector(onLeftBarButtonClicked))
    }
    
    @objc func onLeftBarButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: UITableView delegates
extension BookDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let bookDetailCell = tableView.dequeueReusableCell(withIdentifier: "BookDetailTableViewCell", for: indexPath) as? BookDetailTableViewCell else {
            return UITableViewCell()
        }
        prepareCell(bookDetailCell, atIndexPath: indexPath)
        return bookDetailCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

//MARK: Cells preparation methods
extension BookDetailsViewController {
    
    private func prepareCell(_ cell: BookDetailTableViewCell, atIndexPath indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = R.string.localizable.title()
            cell.detailsLabel.text = parseTextForLabel(text: book?.title)
        case 1:
            cell.titleLabel.text = R.string.localizable.author()
            cell.detailsLabel.text = parseTextForLabel(text: book?.authors)
        case 2:
            cell.titleLabel.text = R.string.localizable.publicationYear()
            cell.detailsLabel.text = parseTextForLabel(text: book?.year)
        case 3:
            cell.titleLabel.text = R.string.localizable.bookVolume()
            cell.detailsLabel.text = parseTextForLabel(text: book?.volume)
        case 4:
            cell.titleLabel.text = R.string.localizable.availability()
            cell.detailsLabel.text = parseTextForLabel(text: book?.available)
        case 5:
            cell.titleLabel.text = R.string.localizable.positionType()
            cell.detailsLabel.text = parseTextForLabel(text: book?.type)
        case 6:
            cell.titleLabel.text = R.string.localizable.isbn()
            cell.detailsLabel.text = parseTextForLabel(text: book?.isbn)
        case 7:
            cell.titleLabel.text = R.string.localizable.mathLibrarySignature()
            cell.detailsLabel.text = parseTextForLabel(text: book?.mathLibrarySignature)
        case 8:
            cell.titleLabel.text = R.string.localizable.mainLibrarySignature()
            cell.detailsLabel.text = parseTextForLabel(text: book?.mainLibrarySignature)
        case 9:
            cell.titleLabel.text = R.string.localizable.category()
            let categoryNames = getCategoryNames(fromBook: book)
            cell.detailsLabel.text = parseTextForLabel(text: categoryNames)
        default:
            cell.titleLabel.text = ""
            cell.detailsLabel.text = ""
        }
    }
    
    private func getCategoryNames(fromBook book: Book?) -> String {
        let categories: [Category] = book?.categories ?? []
        var categoryNames = ""
        for category in categories {
            let categoryName = category.name ?? ""
            categoryNames = categoryNames + categoryName + "\n"
        }
        return categoryNames
    }
    
    private func parseTextForLabel(text: String?) -> String {
        if let parsedText = text {
            if parsedText.isEmpty {
                return "–"
            } else {
                return parsedText
            }
        }
        return "–"
    }
    
}
