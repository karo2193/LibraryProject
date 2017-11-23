//
//  ListViewController.swift
//  Library
//
//  Created by Kryg Tomasz on 23.11.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class ListViewController: MainVC {

    @IBOutlet weak var titleView: UIView!
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
    
    var books: [Book] = [
        Book(title: "Algebraiczne Aspekty Kryptografii", author: "N. Koblitz", year: 2000),
        Book(title: "Złożoność obliczeniowa", author: "C.H. Papadimitriou", year: 2002),
        Book(title: "Introduction to the Theory of Computation", author: "M. Sipser", year: 1997),
        Book(title: "Classical and Quantum Computation", author: "A.Yu. Kitaev, A.H. Shen, M.N. Vyalyi", year: 2002),
        Book(title: "Algorytmy i struktury danych. Wybrane zagadnienia", author: "Z.J. Czech, S. Deorowicz, P. Fabian", year: 2007),
        Book(title: "Algebraiczne Aspekty Kryptografii", author: "N. Koblitz", year: 2000),
        Book(title: "Złożoność obliczeniowa", author: "C.H. Papadimitriou", year: 2002),
        Book(title: "Introduction to the Theory of Computation", author: "M. Sipser", year: 1997),
        Book(title: "Classical and Quantum Computation", author: "A.Yu. Kitaev, A.H. Shen, M.N. Vyalyi", year: 2002),
        Book(title: "Algorytmy i struktury danych. Wybrane zagadnienia", author: "Z.J. Czech, S. Deorowicz, P. Fabian", year: 2007),
        Book(title: "Algebraiczne Aspekty Kryptografii", author: "N. Koblitz", year: 2000),
        Book(title: "Złożoność obliczeniowa", author: "C.H. Papadimitriou", year: 2002),
        Book(title: "Introduction to the Theory of Computation", author: "M. Sipser", year: 1997),
        Book(title: "Classical and Quantum Computation", author: "A.Yu. Kitaev, A.H. Shen, M.N. Vyalyi", year: 2002),
        Book(title: "Algorytmy i struktury danych. Wybrane zagadnienia", author: "Z.J. Czech, S. Deorowicz, P. Fabian", year: 2007)
    ]
    
    weak var delegate: MainPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor(to: .main)
        tableView.separatorColor = .tintDark
        addParallaxEffect()
    }
    
    private func addParallaxEffect() {
        titleView.addParallaxEffect(15)
        tableView.addParallaxEffect(15)
        backButton.addParallaxEffect(30)
    }
    
    @objc func onButtonClicked() {
        delegate?.previousViewController(from: self)
    }

}

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
        let book = books[indexPath.row]
        bookCell.fill(using: book)
        return bookCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? BookTableViewCell else {
            return
        }
        selectedCell.setSelected(false, animated: true)
        
        guard let coverVC = R.storyboard.main().instantiateViewController(withIdentifier: "BookCoverViewController") as? BookCoverViewController else { return }
        let book = books[indexPath.row]
        coverVC.book = book
        present(coverVC, animated: true, completion: nil)
    }
    
}
