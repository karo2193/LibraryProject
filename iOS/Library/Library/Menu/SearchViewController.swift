//
//  SearchViewController.swift
//  Library
//
//  Created by Kryg Tomasz on 29.10.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class SearchViewController: MainVC {

    @IBOutlet weak var titleView: UIView! {
        didSet {
            titleView.backgroundColor = .main
            titleView.addShadow()
        }
    }
    @IBOutlet weak var viewTitleLabel: UILabel! {
        didSet {
            viewTitleLabel.textColor = .tintDark
            viewTitleLabel.text = R.string.localizable.bookSearch()
            
        }
    }
    @IBOutlet weak var titleSeparatorView: UIView! {
        didSet {
            titleSeparatorView.backgroundColor = .tintDark
        }
    }
    @IBOutlet weak var searchButton: LoadingButton! {
        didSet {
            searchButton.appTheme()
            searchButton.setTitle(R.string.localizable.search(), for: .normal)
            searchButton.addTarget(self, action: #selector(onSearchButtonClicked), for: .touchUpInside)
            searchButton.addShadow()
        }
    }
    
    weak var delegate: MainPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor(to: .main)
        addParallaxEffect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchButton.isUserInteractionEnabled = true
    }
    
    private func addParallaxEffect() {
        searchButton.addParallaxEffect(20)
    }
    
    @objc func onSearchButtonClicked() {
        searchButton.showIndicator()
        searchButton.isUserInteractionEnabled = false
        var searchedBook = Book()
        RequestManager.shared.getBooks(searchedBook: searchedBook,completion: goToListViewController)
    }
    
    func goToListViewController(with books: [Book]) {
        searchButton.hideIndicator()
        DispatchQueue.main.async {
            self.delegate?.nextViewController(from: self, books: books)
        }
    }
    
//    private func showLoginScreen() {
//        let storyboard = R.storyboard.login()
//        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
//        loginVC.modalPresentationStyle = .overCurrentContext
//        self.present(loginVC, animated: true, completion: nil)
//    }

}
