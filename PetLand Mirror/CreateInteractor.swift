//
//  CreateInteractor.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 05.12.2022.
//

import UIKit

final class CreateInteractor {
    var presenter: CreatePresentationLogic?
    private let firestoreManager: FirestoreManagerProtocol = FirestoreManager.shared
    private let storageManager: StorageManagerProtocol = StorageManager.shared
}

extension CreateInteractor: CreateBusinessLogic {
    func addPet(_ data: Pet, withImage image: UIImage) {
        firestoreManager.addItem(data, to: .pets) { [weak self] error in
            if let error {
                self?.presenter?.presentError(error)
            } else {
                self?.storageManager.uploadImage(image, withID: data.imageID) { error in
                    if let error {
                        self?.presenter?.presentError(error)
                    } else {
                        self?.presenter?.presentCompletion()
                    }
                }
            }
        }
    }
}
