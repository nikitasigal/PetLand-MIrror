//
//  RegisterInteractor.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 23.12.2022.
//

final class RegisterInteractor {
    var presenter: RegisterPresentationLogic?
    private var authManager = AuthManager.shared
    private var firestoreManager = FirestoreManager.shared
}

extension RegisterInteractor: RegisterBusinessLogic {
    func register(_ user: User, withPassword password: String) {
        authManager.register(email: user.email, password: password) { error in
            if let error {
                self.presenter?.presentError(error)
                return
            }
            
            var newUser = user
            newUser.uid = self.authManager.currentUserID

            self.firestoreManager.addItem(newUser, to: .users) { error in
                if let error {
                    self.presenter?.presentError(error)
                } else {
                    self.presenter?.presentCompletion()
                }
            }
        }
    }
}
