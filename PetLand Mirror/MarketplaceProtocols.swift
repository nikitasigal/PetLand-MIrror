//
//  MarketplaceProtocols.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 04.12.2022.
//

import UIKit

protocol MarketplaceBusinessLogic {
    func fetchPets()
    func fetchImage(withID: String)
    func fetchCurrentUser()
    func updateFavourites(to newValue: Set<String>)
}

protocol MarketplacePresentationLogic {
    func presentError(_ error: Error)
    func presentPets(_ data: [Pet])
    func presentImage(_ image: UIImage, withID imageID: String)
    func presentCurrentUser(_ data: User)
}

protocol MarketplaceDisplayLogic: AnyObject {
    func displayError(_ error: Error)
    func displayPets(_ data: [Pet])
    func displayImage(_ image: UIImage, withID imageID: String)
    func displayCurrentUser(_ data: User)
}

protocol MarketplaceRoutingLogic: AnyObject {
    func routeToFilter()
    func routeToCreatePet(callback: (() -> Void)?)
    func routeToDetail()
}
