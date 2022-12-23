//
//  RegisterProtocols.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 23.12.2022.
//

protocol RegisterBusinessLogic {
    func register(_ data: User, withPassword password: String)
}

protocol RegisterPresentationLogic {
    func presentError(_ error: Error)
    func presentCompletion()
}

protocol RegisterDisplayLogic: AnyObject {
    func displayError(_ error: Error)
    func displayCompletion()
}
