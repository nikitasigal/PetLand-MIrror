//
//  LoginPresenter.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 24.12.2022.
//

final class LoginPresenter {
    weak var viewController: LoginDisplayLogic?
}

extension LoginPresenter: LoginPresentationLogic {
    func presentError(_ error: Error) {
        viewController?.displayError(error)
    }
    
    func presentCompletion() {
        viewController?.displayCompletion()
    }
}
