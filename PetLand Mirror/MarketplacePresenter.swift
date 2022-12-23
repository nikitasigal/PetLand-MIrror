//
//  MarketplacePresentor.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 04.12.2022.
//

import UIKit

final class MarketplacePresenter {
    weak var viewController: MarketplaceDisplayLogic?
}

// MARK: Presentation Logic

extension MarketplacePresenter: MarketplacePresentationLogic {
    func presentError(_ error: Error) {
        viewController?.displayError(error)
    }
    func presentPets(_ data: [Pet]) {
        viewController?.displayPets(data)
    }
    func presentImage(_ image: UIImage, withID imageID: String) {
        viewController?.displayImage(image, withID: imageID)
    }

    func presentCurrentUser(_ data: User) {
        viewController?.displayCurrentUser(data)
    }
}
