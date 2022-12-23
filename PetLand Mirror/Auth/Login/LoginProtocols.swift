//
//  LoginProtocols.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 24.12.2022.
//

protocol LoginBusinessLogic {
    func login(email: String, password: String)
}

protocol LoginPresentationLogic {
    func presentError(_ error: Error)
    func presentCompletion()
}

protocol LoginDisplayLogic: AnyObject {
    func displayError(_ error: Error)
    func displayCompletion()
}
