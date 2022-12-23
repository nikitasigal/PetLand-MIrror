//
//  MarketplaceMainAssembler.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 19.11.2022.
//

import Foundation
import UIKit

enum MarketplaceMainAssembler {
    static func assembly() -> UIViewController {
        let authManager: AuthManagerProtocol = AuthManager.shared
        return MarketplaceMainVC(authManager)
    }
}
