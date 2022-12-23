//
//  CreatePresenter.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 05.12.2022.
//

import UIKit

final class CreatePresenter {
    weak var viewController: CreateDisplayLogic?
}

extension CreatePresenter: CreatePresentationLogic {
    func presentError(_ error: Error) {
        viewController?.displayError(error)
    }

    func presentCompletion() {
        viewController?.displayCompletion()
    }
}
