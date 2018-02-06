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
    case year
    case volume
    case availability
    case type
    case isbn
    case mathSignature
    case mainSignature
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
            textField.addDoneButtonAboveKeyboard()
        }
    }
    @IBOutlet weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = .tintDark
        }
    }
    
    private var pickerView: UIPickerView?
    weak var delegate: SearchTextTableViewCellDelegate?
    var searchPropertyType: SearchPropertyType = .none {
        didSet {
            switch searchPropertyType {
            case .type, .availability:
                pickerView = UIPickerView()
                pickerView?.delegate = self
                pickerView?.dataSource = self
                textField.inputView = pickerView
                textField.placeholder = R.string.localizable.choose() + "..."
            case .mathSignature, .year:
                textField.keyboardType = .numberPad
                textField.inputView = nil
                textField.placeholder = R.string.localizable.typePhraseToSearch() + "..."
            default:
                textField.keyboardType = .default
                textField.inputView = nil
                textField.placeholder = R.string.localizable.typePhraseToSearch() + "..."
            }
        }
    }
    var row: Int = 0 {
        didSet {
            setPropertyType()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTapGesture()
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onCellTap))
        contentView.addGestureRecognizer(tapGesture)
        contentView.isUserInteractionEnabled = true
    }
    
    @objc func onCellTap() {
        textField.becomeFirstResponder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setPropertyType() {
        switch row {
        case 0:
            searchPropertyType = .title
        case 1:
            searchPropertyType = .author
        case 2:
            searchPropertyType = .year
        case 3:
            searchPropertyType = .volume
        case 4:
            searchPropertyType = .availability
        case 5:
            searchPropertyType = .type
        case 6:
            searchPropertyType = .isbn
        case 7:
            searchPropertyType = .mathSignature
        case 8:
            searchPropertyType = .mainSignature
        case 9:
            searchPropertyType = .category
        default:
            searchPropertyType = .none
        }
    }
    
}

//MARK: UITextField delegates
extension SearchTextTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if
            var text = textField.text,
            let textRange = Range(range, in: text) {
                text = text.replacingCharacters(in: textRange, with: string)
                delegate?.fill(text: text, forType: searchPropertyType)
        }
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

extension SearchTextTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch searchPropertyType {
        case .type:
            return SessionManager.shared.dictionaryTypes.type.count
        case .availability:
            return SessionManager.shared.dictionaryTypes.availability.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch searchPropertyType {
        case .type:
            return SessionManager.shared.dictionaryTypes.type[row]
        case .availability:
            return SessionManager.shared.dictionaryTypes.availability[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let dictionaryTypes = SessionManager.shared.dictionaryTypes
        switch searchPropertyType {
        case .type:
            let type = dictionaryTypes?.type[row]
            SessionManager.shared.searchedBook.bookType = type
            textField.text = type
        case .availability:
            let availability = dictionaryTypes?.availability[row]
            SessionManager.shared.searchedBook.bookAvailable = availability
            textField.text = availability
        default:
            return
        }
        textField.resignFirstResponder()
    }
    
}
