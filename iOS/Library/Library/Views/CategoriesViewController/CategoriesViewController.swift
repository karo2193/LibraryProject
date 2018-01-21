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
            tableView.register(R.nib.mainCategoryHeaderView(), forHeaderFooterViewReuseIdentifier: "MainCategoryHeaderView")
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
            let rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "trash").scale(toWidth: 24, height: 24), style: .plain, target: self, action: #selector(onRightBarButtonClicked))
            delegate?.initNavigationBar(withTitle: R.string.localizable.categories(), rightButton: rightButtonItem)
        }
    }
    var selectedHeaders: [Bool] = []
    var selectedCells: [IndexPath:Bool] = [:]
    var expandedHeaders: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor(to: .main)
        deselectAllHeaders()
        collapseAllHeaders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectSavedCategories()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        acceptButton.isUserInteractionEnabled = true
//        selectSavedCategories()
    }
    
    @objc func onAcceptButtonClicked() {
        acceptButton.isUserInteractionEnabled = false
        guard let searchVC = R.storyboard.main().instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else { return }
        searchVC.delegate = self.delegate
        saveSelectedCategories()
        delegate?.next(viewController: searchVC)
    }
    
    @objc func onRightBarButtonClicked() {
        deselectAllHeaders()
        selectedCells.removeAll()
        tableView.reloadData()
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
            selectedCells[indexPath] = true
        }
        trySelectHeaders()
    }
    
    fileprivate func getIndexPaths(forCategory category: Category) -> [IndexPath] {
        let mainCategories = SessionManager.shared.mainCategories
        for (section, mainCategory) in mainCategories.enumerated() {
            guard
                let mainCategoryId = mainCategory.category?.id,
                let categoryId = category.id
                else { continue }
            if mainCategoryId == categoryId {
                toggleHeader(inSection: section, select: true)
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
    
}

//MARK: UITableView Delegate and DataSource
extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SessionManager.shared.mainCategories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expandedHeaders[section] {
            return SessionManager.shared.mainCategories[section].subcategories.count
        } else {
            return 0
        }
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
        if let selected = selectedCells[indexPath],
            selected {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCells[indexPath] = true
        trySelectHeader(inSection: indexPath.section)

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedCells[indexPath] = false
        toggleHeader(inSection: indexPath.section, select: false)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let categoryHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MainCategoryHeaderView") as? MainCategoryHeaderView else {
            return UIView()
        }
        return categoryHeader
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let categoryHeader = view as? MainCategoryHeaderView else { return }
        categoryHeader.delegate = self
        categoryHeader.section = section
        categoryHeader.isSelected = selectedHeaders[section]
        categoryHeader.isExpanded = expandedHeaders[section]
        let mainCategory = SessionManager.shared.mainCategories[section]
        categoryHeader.mainCategory = mainCategory
        if mainCategory.subcategories.isEmpty {
            categoryHeader.expandButton.isHidden = true
        } else {
            categoryHeader.expandButton.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 56
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

//MARK: Header delegate
extension CategoriesViewController: MainCategoryHeaderViewDelegate {
    
    func toggleSubcategories(usingHeader header: MainCategoryHeaderView) {
        let headerIsSelected = selectedHeaders[header.section]
        guard let subcategories = header.mainCategory?.subcategories else { return }
        for (index, _) in subcategories.enumerated() {
            let indexPath = IndexPath(row: index, section: header.section)
            if headerIsSelected {
                tableView.deselectRow(at: indexPath, animated: true)
                selectedCells[indexPath] = false
            } else {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                selectedCells[indexPath] = true
            }
        }
        toggleHeader(inSection: header.section, select: !headerIsSelected)
    }
    
    func expandSubcategories(usingHeader header: MainCategoryHeaderView) {
        var headerIsExpanded = expandedHeaders[header.section]
        headerIsExpanded = !headerIsExpanded
        header.isExpanded = headerIsExpanded
        expandedHeaders[header.section] = headerIsExpanded
        tableView.reloadData()
    }
    
}

//MARK: Selection handlers
extension CategoriesViewController {
    
    private func saveSelectedCategories() {
        SessionManager.shared.searchedBook.categories.removeAll()
        saveMainCategories()
        saveSubcategories()
    }
    
    private func saveMainCategories() {
        for (section, isHeaderSelected) in selectedHeaders.enumerated() {
            if isHeaderSelected {
                guard let category = SessionManager.shared.mainCategories[section].category else { continue }
                SessionManager.shared.searchedBook.categories.append(category)
            }
        }
    }
    
    private func saveSubcategories() {
//        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return }
//        for selectedIndexPath in selectedIndexPaths {
//            guard let selectedCategory = getCategory(forIndexPath: selectedIndexPath) else { continue }
//            SessionManager.shared.searchedBook.categories.append(selectedCategory)
//        }
        
        let mainCategories = SessionManager.shared.mainCategories
        for (section, mainCategory) in mainCategories.enumerated() {
            for (row, subcategory) in mainCategory.subcategories.enumerated() {
                let indexPath = IndexPath(row: row, section: section)
                guard let selected = selectedCells[indexPath] else { continue }
                if selected {
                    SessionManager.shared.searchedBook.categories.append(subcategory)
                }
            }
        }
    }
    
    private func deselectAllHeaders() {
        let mainCategoriesCount = SessionManager.shared.mainCategories.count
        selectedHeaders = Array(repeating: false, count: mainCategoriesCount)
    }
    
    private func toggleHeader(inSection section: Int, select: Bool) {
        selectedHeaders[section] = select
        guard let header = tableView.headerView(forSection: section) as? MainCategoryHeaderView else { return }
        header.isSelected = select
    }
    
    private func trySelectHeaders() {
        let sectionsCount = tableView.numberOfSections
        for section in 0..<sectionsCount {
            trySelectHeader(inSection: section)
        }
    }
    
    private func trySelectHeader(inSection section: Int) {
        let subcategories = SessionManager.shared.mainCategories[section].subcategories
        if subcategories.isEmpty { return }
        for (index, _) in subcategories.enumerated() {
            let indexPath = IndexPath(row: index, section: section)
            guard let selected = selectedCells[indexPath] else { return }
            if !selected {
                toggleHeader(inSection: indexPath.section, select: false)
                return
            }
        }
        toggleHeader(inSection: section, select: true)
    }
    
}

//MARK: Expanding/collapsing handlers
extension CategoriesViewController {
    
    func collapseAllHeaders() {
        let mainCategoriesCount = SessionManager.shared.mainCategories.count
        expandedHeaders = Array(repeating: false, count: mainCategoriesCount)
    }
    
}
