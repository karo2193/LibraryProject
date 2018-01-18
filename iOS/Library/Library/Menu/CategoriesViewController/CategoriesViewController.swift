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
            acceptButton.setTitle(R.string.localizable.accept(), for: .normal)
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectSavedCategories()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        acceptButton.isUserInteractionEnabled = true
    }
    
    @objc func onAcceptButtonClicked() {
        acceptButton.isUserInteractionEnabled = false
        guard let searchVC = R.storyboard.main().instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else { return }
        searchVC.delegate = self.delegate
        saveSelectedCategories()
        delegate?.next(viewController: searchVC)
    }
    
    private func saveSelectedCategories() {
        SessionManager.shared.searchedBook.categories.removeAll()
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return }
        for selectedIndexPath in selectedIndexPaths {
            guard let selectedCategory = getCategory(forIndexPath: selectedIndexPath) else { continue }
            SessionManager.shared.searchedBook.categories.append(selectedCategory)
        }
    }
    
    
    
}

//MARK: Autoselecting saved categories
extension CategoriesViewController {
    
    fileprivate func selectSavedCategories() {
        let selectedCategories = SessionManager.shared.searchedBook.categories
        var selectedIndexPaths: [IndexPath] = []
        for selectedCategory in selectedCategories {
            let indexPaths = getIndexPaths(forCategory: selectedCategory)
            selectedIndexPaths.append(contentsOf: indexPaths)
        }
        for indexPath in selectedIndexPaths {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }
    
    fileprivate func getIndexPaths(forCategory category: Category) -> [IndexPath] {
        let mainCategories = SessionManager.shared.mainCategories
        for (section, mainCategory) in mainCategories.enumerated() {
            guard
                let mainCategoryId = mainCategory.category?.id,
                let categoryId = category.id
                else { continue }
            if mainCategoryId == categoryId {
                return getIndexPaths(fromSection: section)
            } else {
                guard let indexPath = getIndexPath(forCategory: category, inSection: section) else { continue }
                return [indexPath]
            }
        }
        return []
    }
    
    fileprivate func getIndexPaths(fromSection section: Int) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        let rowsCount = tableView.numberOfRows(inSection: section)
        for row in 0..<rowsCount {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        return indexPaths
    }
    
    fileprivate func getIndexPath(forCategory category: Category, inSection section: Int) -> IndexPath? {
        let mainCategory = SessionManager.shared.mainCategories[section]
        for (row, subcategory) in mainCategory.subcategories.enumerated() {
            guard let subcategoryId = subcategory.id,
                let categoryId = category.id else { continue }
            if subcategoryId == categoryId {
                let indexPath = IndexPath(row: row, section: section)
                return indexPath
            }
        }
        return nil
    }
    
    //    private func selectSavedCategories() {
    //        let selectedCategories = SessionManager.shared.searchedBook.categories
    //        let mainCategories = SessionManager.shared.mainCategories
    //        var selectedIndexPaths: [IndexPath] = []
    //        for selectedCategoryIdObject in selectedCategories.map({$0.id}) {
    //            guard let selectedCategoryId = selectedCategoryIdObject else { continue }
    //            for (section, mainCategory) in mainCategories.enumerated() {
    //                guard let categoryId = mainCategory.category?.id else { continue }
    //                if categoryId == selectedCategoryId {
    //                    let indexPaths = getIndexPaths(fromSection: section)
    //                    selectedIndexPaths.append(contentsOf: indexPaths)
    //                    continue
    //                }
    //                for (row, subcategory) in mainCategory.subcategories.enumerated() {
    //                    guard let subcategoryId = subcategory.id else { continue }
    //                    if subcategoryId == selectedCategoryId {
    //                        let selectedIndexPath = IndexPath(row: row, section: section)
    //                        selectedIndexPaths.append(selectedIndexPath)
    //                        break
    //                    }
    //                }
    //            }
    //        }
    //
    //        for indexPath in selectedIndexPaths {
    //            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
    //        }
    //    }
    
}

//MARK: UITableView Delegate and DataSource
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
        categoryCell.selectionStyle = .none
        let rowsCount = tableView.numberOfRows(inSection: indexPath.section)
        if indexPath.row == rowsCount - 1 {
            categoryCell.separatorView.isHidden = true
        } else {
            categoryCell.separatorView.isHidden = false
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let categoryCell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell else { return }
//    }
    
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
