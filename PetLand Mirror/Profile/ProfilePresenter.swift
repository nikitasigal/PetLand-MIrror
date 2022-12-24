//
//  ProfilePresenter.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 24.12.2022.
//

import UIKit

final class ProfilePresenter {
    weak var viewController: ProfileDisplayLogic?
}

extension ProfilePresenter: ProfilePresentationLogic {
    func presentCurrentUser(_ user: User) {
        viewController?.displayCurrentUser(user)
    }
    
    func presentImage(_ image: UIImage) {
        viewController?.displayImage(image)
    }
    
    func presentError(_ error: Error) {
        viewController?.displayError(error)
    }
    
    func presentLogout() {
        viewController?.displayLogout()
    }
}
