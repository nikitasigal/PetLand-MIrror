//
//  AuthManager.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 14.11.2022.
//

import FirebaseAuth
import Foundation

protocol AuthManagerProtocol {
    func login(email: String, password: String, completion: @escaping (Error?) -> Void)
    func register(email: String, password: String, completion: @escaping (Error?) -> Void)
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
               completion: @escaping (Error?) -> Void)
    {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            completion(error)
        }
    }

    func register(email: String, password: String,
                  completion: @escaping (Error?) -> Void)
    {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            completion(error)
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
