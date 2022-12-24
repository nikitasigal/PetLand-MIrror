//
//  LoginInteractor.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 24.12.2022.
//

final class LoginInteractor {
    var presenter: LoginPresentationLogic?
    private var authManager: AuthManagerProtocol = AuthManager.shared
}

extension LoginInteractor: LoginBusinessLogic {
    func login(email: String, password: String) {
        authManager.login(email: email, password: password) { error in
            if let error {
                self.presenter?.presentError(error)
            } else {
                self.presenter?.presentCompletion()
            }
        }
    }
}
