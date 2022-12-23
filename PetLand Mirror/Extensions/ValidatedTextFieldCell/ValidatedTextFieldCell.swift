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
    private var bottomLine: CALayer = CALayer()

    @IBOutlet var textField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var visibilityToggle: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        visibilityToggle.isHidden = true
        errorLabel.isHidden = true
        textField.delegate = self
        
        bottomLine.frame = CGRect(x: 0.0, y: textField.frame.height - 1, width: textField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.red.cgColor
        bottomLine.isHidden = true
        textField.layer.addSublayer(bottomLine)
    }

    @IBAction func onEditingChanged() {
        if textField.hasText,
           let error = validator(textField.text!)
        {
            errorLabel.text = error
            bottomLine.isHidden = false
            errorLabel.isHidden = false
        } else {
            bottomLine.isHidden = true
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
