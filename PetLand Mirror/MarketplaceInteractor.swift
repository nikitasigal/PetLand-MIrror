//
//  MarketplaceInteractor.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 04.12.2022.
//

final class MarketplaceInteractor {
    var presenter: MarketplacePresentationLogic?
    private let authManager: AuthManagerProtocol = AuthManager.shared
    private let firestoreManager: FirestoreManagerProtocol = FirestoreManager.shared
    private let storageManager: StorageManagerProtocol = StorageManager.shared
}

// MARK: Business Logic

extension MarketplaceInteractor: MarketplaceBusinessLogic {
    func fetchPets() {
        firestoreManager.getItems(from: .pets, as: Pet.self) { result in
            switch result {
            case .success(let data):
                _ = data.map { item in
                    self.fetchImage(withID: item.imageID)
                }
                self.presenter?.presentPets(data)
            case .failure(let error):
                self.presenter?.presentError(error)
            }
        }
    }

    func fetchImage(withID imageID: String) {
        storageManager.getImage(withID: imageID) { result in
            switch result {
            case .success(let image):
                self.presenter?.presentImage(image, withID: imageID)
            case .failure(let error):
                self.presenter?.presentError(error)
            }
        }
    }

    func fetchCurrentUser() {
        guard let userID = authManager.currentUserID else {
            presenter?.presentError(AuthError.notSignedIn)
            return
        }

        firestoreManager.getItem(from: .users, withID: userID, as: User.self) { result in
            switch result {
            case .success(let user):
                self.fetchImage(withID: user.imageID)
                self.presenter?.presentCurrentUser(user)
            case .failure(let error):
                self.presenter?.presentError(error)
            }
        }
    }
    
    func updateFavourites(to newValue: Set<String>) {
        guard let userID = authManager.currentUserID else {
            presenter?.presentError(AuthError.notSignedIn)
            return
        }
        
        firestoreManager.updateItem(in: .users,
                                    withID: userID,
                                    for: "favourites",
                                    set: Array(newValue)) { error in
            if let error {
                self.presenter?.presentError(error)
            } else {
                self.fetchCurrentUser()
            }
        }
    }
}
