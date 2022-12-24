//
//  ProfileProtocols.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 24.12.2022.
//

import UIKit

protocol ProfileBusinessLogic {
    func fetchCurrentUser()
    func fetchImage(withID imageID: String)
    func logout()
}

protocol ProfilePresentationLogic {
    func presentCurrentUser(_ user: User)
    func presentImage(_ image: UIImage)
    func presentLogout()
    func presentError(_ error: Error)
}

protocol ProfileDisplayLogic: AnyObject {
    func displayCurrentUser(_ user: User)
    func displayImage(_ image: UIImage)
    func displayLogout()
    func displayError(_ error: Error)
}
