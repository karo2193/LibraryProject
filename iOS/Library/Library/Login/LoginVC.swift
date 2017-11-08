//
//  LoginVC.swift
//  Library
//
//  Created by Kryg Tomasz on 29.10.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class LoginVC: MainVC {

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.keyboardDismissMode = .interactive
        }
    }
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.borderWidth = 1.0
            containerView.layer.borderColor = UIColor.main.cgColor
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = .main
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.textColor = .main
        }
    }
    @IBOutlet weak var leftSeparator: UIView! {
        didSet {
            leftSeparator.backgroundColor = .main
        }
    }
    @IBOutlet weak var rightSeparator: UIView! {
        didSet {
            rightSeparator.backgroundColor = .main
        }
    }
    @IBOutlet weak var loginImageView: UIImageView! {
        didSet {
            loginImageView.image = #imageLiteral(resourceName: "login").withRenderingMode(.alwaysTemplate)
            loginImageView.tintColor = .main
        }
    }
    @IBOutlet weak var loginTextField: UITextField! {
        didSet {
            loginTextField.textColor = .main
            loginTextField.tintColor = .main
            let placeholderText = R.string.localizable.enterLogin()
            loginTextField.attributedPlaceholder = getPlaceholderAttributedString(using: placeholderText)
            loginTextField.delegate = self
        }
    }
    @IBOutlet weak var loginSeparator: UIView! {
        didSet {
            loginSeparator.backgroundColor = .main
        }
    }
    @IBOutlet weak var passwordImageView: UIImageView! {
        didSet {
            passwordImageView.image = #imageLiteral(resourceName: "password").withRenderingMode(.alwaysTemplate)
            passwordImageView.tintColor = .main
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.textColor = .main
            passwordTextField.tintColor = .main
            let placeholderText = R.string.localizable.enterPassword()
            passwordTextField.attributedPlaceholder = getPlaceholderAttributedString(using: placeholderText)
            passwordTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordSeparator: UIView! {
        didSet {
            passwordSeparator.backgroundColor = .main
        }
    }
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.backgroundColor = .main
            loginButton.setTitleColor(.tint, for: .normal)
            loginButton.addTarget(self, action: #selector(onLoginButtonClicked), for: .touchUpInside)
        }
    }
    @IBOutlet weak var ornamentImageView: UIImageView! {
        didSet {
            ornamentImageView.image = #imageLiteral(resourceName: "ornament").withRenderingMode(.alwaysTemplate)
            ornamentImageView.tintColor = .main
        }
    }
    
    var login: String = ""
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor(to: .tint)
    }
    
    private func getPlaceholderAttributedString(using text: String) -> NSMutableAttributedString {
        let range = (text as NSString).range(of: text)
        let placeholder = NSMutableAttributedString(string: text)
        let placeholderColor = UIColor.main.withAlphaComponent(0.3)
        placeholder.addAttribute(NSAttributedStringKey.foregroundColor, value: placeholderColor, range: range)
        return placeholder
    }
    
    @objc func onLoginButtonClicked() {
        login = loginTextField.text ?? ""
        password = passwordTextField.text ?? ""
        tryToLogin(using: login, password)
    }
    
    private func tryToLogin(using login: String, _ password: String) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: Text Field Delegates
extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
