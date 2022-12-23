//
//  Login.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 14.11.2022.
//

import UIKit
import FirebaseAuth

final class LoginVC: UIViewController {
    static let identifier = "Auth.Login"
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var statusLabel: UILabel!

    let authManager: AuthManagerProtocol = AuthManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false

        emailTF.delegate = self
        passwordTF.delegate = self
    }

    @IBAction func onTextFieldEditingChanged(_: Any) {
        loginButton.isEnabled = emailTF.hasText && passwordTF.hasText
    }

    @IBAction func onLoginButtonPress() {
        authManager.login(email: emailTF.text!,
                          password: passwordTF.text!) { error in
            if let error {
                self.statusLabel.text = error.localizedDescription
                return
            }
            
            let vc = UIStoryboard(name: "Navigation", bundle: nil)
                .instantiateViewController(withIdentifier: "TabBar")
            self.present(vc, animated: true)
        }
    }

    @IBAction func onPasswordEditingEnd() {
        passwordTF.resignFirstResponder()
        onLoginButtonPress()
    }
}

// MARK: - UITextFieldDelegate

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
