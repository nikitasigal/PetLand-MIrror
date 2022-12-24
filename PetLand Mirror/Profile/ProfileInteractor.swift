//
//  ProfileInteractor.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 24.12.2022.
//

import UIKit

final class ProfileInteractor {
    var presenter: ProfilePresentationLogic?
    private let authManager: AuthManagerProtocol = AuthManager.shared
    private let firestoreManager: FirestoreManagerProtocol = FirestoreManager.shared
    private let storageManager: StorageManagerProtocol = StorageManager.shared
}

extension ProfileInteractor: ProfileBusinessLogic {
    func logout() {
        authManager.logout { error in
            if let error {
                self.presenter?.presentError(error)
            } else {
                self.presenter?.presentLogout()
            }
        }
    }
    
    func fetchCurrentUser() {
        guard let currentUserID = authManager.currentUserID else {return}
        
        firestoreManager.getItem(from: .users, withID: currentUserID, as: User.self) { result in
            switch result {
                case .success(let user):
                    self.fetchImage(withID: user.imageID)
                    self.presenter?.presentCurrentUser(user)
                case .failure(let error):
                    self.presenter?.presentError(error)
            }
        }
        
    }
    
    func fetchImage(withID imageID: String) {
        storageManager.getImage(withID: imageID) { result in
            switch result {
                case .success(let image):
                    self.presenter?.presentImage(image)
                case .failure(let error):
                    self.presenter?.presentError(error)
            }
        }
    }
}
