//
//  RegisterPresenter.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 23.12.2022.
//

import UIKit

final class RegisterPresenter {
    weak var viewController: RegisterDisplayLogic?
}

extension RegisterPresenter: RegisterPresentationLogic {
    func presentError(_ error: Error) {
        viewController?.displayError(error)
    }
    
    func presentCompletion() {
        viewController?.displayCompletion()
    }
}
