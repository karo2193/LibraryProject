//
//  BookCoverViewController.swift
//  Library
//
//  Created by Kryg Tomasz on 23.11.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class BookCoverViewController: MainVC {

    @IBOutlet weak var container: UIView! {
        didSet {
            container.layer.borderWidth = 1.0
            container.layer.borderColor = UIColor.main.cgColor
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = .main
        }
    }
    @IBOutlet weak var leftSeparatorView: UIView! {
        didSet {
            leftSeparatorView.backgroundColor = .main
        }
    }
    @IBOutlet weak var rightSeparatorView: UIView! {
        didSet {
            rightSeparatorView.backgroundColor = .main
        }
    }
    @IBOutlet weak var ornamentImageView: UIImageView! {
        didSet {
            ornamentImageView.image = #imageLiteral(resourceName: "ornament").withRenderingMode(.alwaysTemplate)
            ornamentImageView.tintColor = .main
        }
    }
    @IBOutlet weak var authorLabel: UILabel! {
        didSet {
            authorLabel.textColor = .main
        }
    }
    @IBOutlet weak var yearLabel: UILabel! {
        didSet {
            yearLabel.textColor = .main
        }
    }
    
    var book: Book? {
        didSet {
            self.view.layoutIfNeeded()
            titleLabel.text = book?.title
            authorLabel.text = book?.author
            guard let yearInt = book?.year else { return }
            yearLabel.text = "\(yearInt)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor(to: .tintLight)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapGesture))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func onTapGesture() {
        dismiss(animated: true, completion: nil)
    }

}
