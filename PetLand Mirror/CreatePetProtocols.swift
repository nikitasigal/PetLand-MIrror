//
//  CreatePetProtocols.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 05.12.2022.
//

import UIKit

protocol CreateDisplayLogic: AnyObject {
    func displayError(_ error: Error)
    func displayCompletion()
    
}

protocol CreatePresentationLogic {
    func presentError(_ error: Error)
    func presentCompletion()
}

protocol CreateBusinessLogic {
    func addPet(_ data: Pet, withImage: UIImage)
}
