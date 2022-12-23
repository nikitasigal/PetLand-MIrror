//
//  ValidatedTextFieldCell.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 30.11.2022.
//

import Foundation
import UIKit

final class ValidatedTextFieldCell: UITableViewCell {
    static let identifier = "ValidatedTextFieldCell"

    enum CellType {
        case text, firstName, lastName, email, username, newPassword, confirmPassword
    }

    private var type: CellType = .newPassword

    @IBOutlet var textField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var visibilityToggle: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        visibilityToggle.isHidden = true
        errorLabel.isHidden = true
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.red.cgColor
        textField.delegate = self
    }

    @IBAction func onEditingChanged() {
        if textField.hasText,
           let error = validator(textField.text!)
        {
            textField.layer.borderWidth = 1
            errorLabel.text = error
            errorLabel.isHidden = false
        } else {
            textField.layer.borderWidth = 0
            errorLabel.isHidden = true
        }
    }

    @IBAction func onVisibilityTogglePress() {
        textField.isSecureTextEntry.toggle()
        visibilityToggle.setImage(textField.isSecureTextEntry
            ? UIImage(systemName: "eye.slash")
            : UIImage(systemName: "eye.slash.fill"),
            for: .normal)
    }
}

extension ValidatedTextFieldCell {
    func configure(placeholder: String, type: CellType) {
        textField.placeholder = placeholder
        self.type = type

        switch type {
        case .firstName:
            textField.textContentType = .givenName
            textField.keyboardType = .namePhonePad
        case .lastName:
            textField.textContentType = .familyName
            textField.keyboardType = .namePhonePad
        case .username:
            textField.textContentType = .username
            textField.keyboardType = .asciiCapable
            textField.spellCheckingType = .no
        case .email:
            textField.textContentType = .emailAddress
            textField.keyboardType = .emailAddress
            textField.spellCheckingType = .no
        case .newPassword, .confirmPassword:
            textField.textContentType = .newPassword
            textField.keyboardType = .asciiCapable
            textField.isSecureTextEntry = true
            visibilityToggle.isHidden = false
        case .text:
            break
        }
    }

    private var validator: (String) -> String? {
        switch type {
        case .firstName, .lastName, .text:
            return ValidationManager.isValidName
        case .username:
            return ValidationManager.isValidUsername
        case .email:
            return ValidationManager.isValidEmail
        case .newPassword:
            return ValidationManager.isValidPassword
        case .confirmPassword:
            return ValidationManager.isValidConfirmPassword
        }
    }

    var isValid: Bool {
        textField.hasText && errorLabel.isHidden
    }

    var text: String? {
        textField.text
    }
}

extension ValidatedTextFieldCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
