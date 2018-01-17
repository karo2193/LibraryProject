//
//  SearchTextTableViewCell.swift
//  Library
//
//  Created by Kryg Tomasz on 13.01.2018.
//  Copyright © 2018 Kryg Tomek. All rights reserved.
//

import UIKit

enum SearchPropertyType {
    case title
    case author
    case isbn
    case mathSignature
    case mainSignature
    case year
    case volume
    case type
    case availability
    case category
    case none
}

protocol SearchTextTableViewCellDelegate: class {
    func fill(text: String, forType type: SearchPropertyType)
}

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
    
    weak var delegate: SearchTextTableViewCellDelegate?
    var searchPropertyType: SearchPropertyType = .none
    var row: Int = 0 {
        didSet {
            setPropertyType()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setPropertyType() {
        switch row {
        case 0:
            searchPropertyType = .title
        case 1:
            searchPropertyType = .author
        case 2:
            searchPropertyType = .isbn
        case 3:
            searchPropertyType = .mathSignature
        case 4:
            searchPropertyType = .mainSignature
        case 5:
            searchPropertyType = .year
        case 6:
            searchPropertyType = .volume
        case 7:
            searchPropertyType = .type
        case 8:
            searchPropertyType = .category
        case 9:
            searchPropertyType = .availability
        default:
            searchPropertyType = .none
        }
    }
    
}

//MARK: UITextField delegates
extension SearchTextTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var text = textField.text ?? ""
        text = text + string
        delegate?.fill(text: text, forType: searchPropertyType)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        delegate?.fill(text: "", forType: searchPropertyType)
        textField.resignFirstResponder()
        return false // Used to resignFirstResponder. True value triggers also becomeFirstResponder().
    }
    
}
