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
            tableView.register(R.nib.categoryTableViewCell(), forCellReuseIdentifier: "CategoryTableViewCell")
            tableView.delegate = self
            tableView.dataSource = self
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
        categoryCell.titleLabel.text = getCategoryName(forIndexPath: indexPath)
    }
    
    private func getCategoryName(forIndexPath indexPath: IndexPath) -> String? {
        let section = indexPath.section
        let row = indexPath.row
        let mainCategory = SessionManager.shared.mainCategories[section]
        let category = mainCategory.subcategories[row]
        return category.name
    }
    
}
