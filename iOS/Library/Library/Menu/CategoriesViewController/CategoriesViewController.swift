//
//  CategoriesViewController.swift
//  Library
//
//  Created by Kryg Tomasz on 17.01.2018.
//  Copyright © 2018 Kryg Tomek. All rights reserved.
//

import UIKit

class CategoriesViewController: MainVC {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = .main
            tableView.register(R.nib.categoryHeaderView(), forHeaderFooterViewReuseIdentifier: "CategoryHeaderView")
            tableView.register(R.nib.categoryTableViewCell(), forCellReuseIdentifier: "CategoryTableViewCell")
            tableView.delegate = self
            tableView.dataSource = self
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: DefaultValues.EDGE_INSET_BOTTOM, right: 0)
        }
    }
    @IBOutlet weak var acceptButton: UIButton! {
        didSet {
            acceptButton.appTheme()
            acceptButton.setTitle(R.string.localizable.bookSearch(), for: .normal)
            acceptButton.addTarget(self, action: #selector(onAcceptButtonClicked), for: .touchUpInside)
            acceptButton.addShadow()
        }
    }
    
    weak var delegate: MainPageViewControllerDelegate? {
        didSet {
            delegate?.initNavigationBar(withTitle: R.string.localizable.categories())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor(to: .main)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        acceptButton.isUserInteractionEnabled = true
    }
    
    @objc func onAcceptButtonClicked() {
        acceptButton.isUserInteractionEnabled = false
        guard let searchVC = R.storyboard.main().instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else { return }
        searchVC.delegate = self.delegate
        delegate?.next(viewController: searchVC)
    }
    
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SessionManager.shared.mainCategories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SessionManager.shared.mainCategories[section].subcategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let categoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        return categoryCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let categoryCell = cell as? CategoryTableViewCell else { return }
        categoryCell.category = getCategory(forIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let categoryHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CategoryHeaderView") as? CategoryHeaderView else {
            return UIView()
        }
        return categoryHeader
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let categoryHeader = view as? CategoryHeaderView else { return }
        let mainCategory = SessionManager.shared.mainCategories[section]
        categoryHeader.mainCategory = mainCategory
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    private func getCategory(forIndexPath indexPath: IndexPath) -> Category? {
        let section = indexPath.section
        let row = indexPath.row
        let mainCategory = SessionManager.shared.mainCategories[section]
        let category = mainCategory.subcategories[row]
        return category
    }
    
}
