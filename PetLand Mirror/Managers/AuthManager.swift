//
//  AuthManager.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 14.11.2022.
//

import FirebaseAuth
import Foundation

protocol AuthManagerProtocol {
    func login(email: String, password: String, completion: @escaping (Bool) -> Void)
    func register(email: String, password: String, firstName: String, lastName: String, completion: @escaping (Bool) -> Void)
    func logout()
    var currentUserID: String? { get }
}

enum AuthError: Error {
    case notSignedIn
}

// MARK: - AuthManager Class

final class AuthManager {
    static let shared = AuthManager()
    init() {}
}

extension AuthManager: AuthManagerProtocol {
    func login(email: String, password: String,
               completion: @escaping (Bool) -> Void)
    {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            completion(authResult != nil && error == nil)
        }
    }

    func register(email: String, password: String,
                  firstName _: String, lastName _: String,
                  completion: @escaping (Bool) -> Void)
    {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            completion(authResult != nil && error == nil)
        }
    }
    
    func logout() {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
            } catch (_) {}
        }
    }

    var currentUserID: String? {
        Auth.auth().currentUser?.uid
    }
}
