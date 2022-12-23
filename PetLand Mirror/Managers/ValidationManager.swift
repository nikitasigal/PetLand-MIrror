//
//  ValidationManager.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 30.11.2022.
//

import Foundation

class ValidationManager {
    private static var cache = NSCache<NSString, NSString>()

    static func isValidName(_ input: String) -> String? {
        let nameRegex = /[A-Za-z\-.\'’‘ ]+/
        return nameRegex.match(in: input) ? nil : "Unsupported characters"
    }

    static func isValidEmail(_ input: String) -> String? {
        let emailRegex = /[A-Za-z0-9._%+-]+@(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,}/
        return emailRegex.match(in: input) ? nil : "Wrong email format"
    }

    static func isValidUsername(_ input: String) -> String? {
        if input.count < 8 {
            return "Must be at least 8 characters"
        }

        let usernameRegex = /[A-Z0-9a-z_-]+/
        return usernameRegex.match(in: input) ? nil : "Unsupported characters"
    }

    static func isValidPassword(_ input: String) -> String? {
        if input.count < 8 {
            return "Must be at least 8 characters"
        }

        let characherSetRegex = /[A-Z0-9a-z_\-!@#$%^&*]+/
        if !characherSetRegex.match(in: input) {
            return "Unsupported characters"
        }

        let capitalLetterRegex = /.*[A-Z].*/
        if !capitalLetterRegex.match(in: input) {
            return "Must contain at least 1 capital letter"
        }

        let digitRegex = /.*[0-9].*/
        if !digitRegex.match(in: input) {
            return "Must contain at least 1 digit"
        }

        let specialCharacterRegex = /.*[_\-!@#$%^&*].*/
        if !specialCharacterRegex.match(in: input) {
            return "Must contain at least 1 special character"
        }

        cache.setObject(input as NSString, forKey: "NewPassword")
        return nil
    }
    
    static func isValidDecimal(_ input: String) -> String? {
        return Double(input) != nil ? nil : "Wrong decimal format"
    }
    
    static func isValidInteger(_ input: String) -> String? {
        return Int(input) != nil ? nil : "Wrong integer format"
    }

    static func isValidConfirmPassword(_ input: String) -> String? {
        if let cachedPassword = cache.object(forKey: "NewPassword") as? String,
           cachedPassword == input
        {
            return nil
        } else {
            return "Doesn't match the password"
        }
    }
}
