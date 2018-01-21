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
    }
    
    private func initNavigationBar() {
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barStyle = .blackOpaque
        navigationBar?.barTintColor = .tintDark
        navigationBar?.tintColor = .main
        navigationBar?.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.main]
        navigationBar?.topItem?.title = "Detale książki"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "expand").scale(toWidth: 24, height: 24), style: .plain, target: self, action: #selector(onLeftBarButtonClicked))
    }
    
    @objc func onLeftBarButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

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
        
//        guard let bookDetailCell = cell as? BookDetailTableViewCell else {
//            return
//        }
        switch indexPath.row {
        case 0:
            bookDetailCell.titleLabel.text = R.string.localizable.title()
            bookDetailCell.detailsLabel.text = parseTextForLabel(text: book?.title)
        case 1:
            bookDetailCell.titleLabel.text = R.string.localizable.author()
            bookDetailCell.detailsLabel.text = parseTextForLabel(text: book?.authors)
        case 2:
            bookDetailCell.titleLabel.text = R.string.localizable.isbn()
            bookDetailCell.detailsLabel.text = parseTextForLabel(text: book?.isbn)
        case 3:
            bookDetailCell.titleLabel.text = R.string.localizable.mathLibrarySignature()
            bookDetailCell.detailsLabel.text = parseTextForLabel(text: book?.mathLibrarySignature)
        case 4:
            bookDetailCell.titleLabel.text = R.string.localizable.mainLibrarySignature()
            bookDetailCell.detailsLabel.text = parseTextForLabel(text: book?.mainLibrarySignature)
        case 5:
            bookDetailCell.titleLabel.text = R.string.localizable.publicationYear()
            bookDetailCell.detailsLabel.text = parseTextForLabel(text: book?.year)
        case 6:
            bookDetailCell.titleLabel.text = R.string.localizable.bookVolume()
            bookDetailCell.detailsLabel.text = parseTextForLabel(text: book?.volume)
        case 7:
            bookDetailCell.titleLabel.text = R.string.localizable.positionType()
            bookDetailCell.detailsLabel.text = parseTextForLabel(text: book?.type)
        case 8:
            bookDetailCell.titleLabel.text = R.string.localizable.availability()
            bookDetailCell.detailsLabel.text = parseTextForLabel(text: book?.available)
        case 9:
            bookDetailCell.titleLabel.text = R.string.localizable.category()
            let categories: [Category] = book?.categories ?? []
            var categoryNames = ""
            for category in categories {
                let categoryName = category.name ?? ""
                categoryNames = categoryNames + categoryName + "\n"
            }
            bookDetailCell.detailsLabel.text = parseTextForLabel(text: categoryNames)
        default:
            bookDetailCell.titleLabel.text = ""
            bookDetailCell.detailsLabel.text = ""
        }
        bookDetailCell.detailsLabel.sizeToFit()
        
        return bookDetailCell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard let bookDetailCell = cell as? BookDetailTableViewCell else {
//            return
//        }
//        switch indexPath.row {
//        case 0:
//            bookDetailCell.titleLabel.text = R.string.localizable.title()
//            bookDetailCell.detailsLabel.text = parseTextForLabel(text: book?.title)
//        case 1:
//            bookDetailCell.titleLabel.text = R.string.localizable.author()
//            bookDetailCell.detailsLabel.text = parseTextForLabel(text: book?.authors)
//        case 2:
//            bookDetailCell.titleLabel.text = R.string.localizable.isbn()
//            bookDetailCell.detailsLabel.text = parseTextForLabel(text: book?.isbn)
//        case 3:
//            bookDetailCell.titleLabel.text = R.string.localizable.mathLibrarySignature()
//            bookDetailCell.detailsLabel.text = parseTextForLabel(text: book?.mathLibrarySignature)
//        case 4:
//            bookDetailCell.titleLabel.text = R.string.localizable.mainLibrarySignature()
//            bookDetailCell.detailsLabel.text = parseTextForLabel(text: book?.mainLibrarySignature)
//        case 5:
//            bookDetailCell.titleLabel.text = R.string.localizable.publicationYear()
//            bookDetailCell.detailsLabel.text = parseTextForLabel(text: book?.year)
//        case 6:
//            bookDetailCell.titleLabel.text = R.string.localizable.bookVolume()
//            bookDetailCell.detailsLabel.text = parseTextForLabel(text: book?.volume)
//        case 7:
//            bookDetailCell.titleLabel.text = R.string.localizable.positionType()
//            bookDetailCell.detailsLabel.text = parseTextForLabel(text: book?.type)
//        case 8:
//            bookDetailCell.titleLabel.text = R.string.localizable.availability()
//            bookDetailCell.detailsLabel.text = parseTextForLabel(text: book?.available)
//        case 9:
//            bookDetailCell.titleLabel.text = R.string.localizable.category()
//            let categories: [Category] = book?.categories ?? []
//            var categoryNames = ""
//            for category in categories {
//                let categoryName = category.name ?? ""
//                categoryNames = categoryNames + categoryName + "\n"
//            }
//            bookDetailCell.detailsLabel.text = parseTextForLabel(text: categoryNames)
//        default:
//            bookDetailCell.titleLabel.text = ""
//            bookDetailCell.detailsLabel.text = ""
//        }
//        bookDetailCell.detailsLabel.sizeToFit()
//    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func parseTextForLabel(text: String?) -> String {
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
