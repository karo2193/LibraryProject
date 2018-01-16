//
//  SearchTextTableViewCell.swift
//  Library
//
//  Created by Kryg Tomasz on 13.01.2018.
//  Copyright © 2018 Kryg Tomek. All rights reserved.
//

import UIKit

class SearchTextTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = .tintDark
        }
    }
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
            textField.textColor = .tintDark
            textField.placeholder = R.string.localizable.typePhraseToSearch() + "..."
            textField.clearButtonMode = .always
        }
    }
    @IBOutlet weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = .tintDark
        }
    }
    
    var searchedBook: Book?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK: UITextField delegates
extension SearchTextTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        textField.resignFirstResponder()
        return false // Used to resignFirstResponder. True value triggers also becomeFirstResponder().
    }
    
}
