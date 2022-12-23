//
//  UserModel.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 15.12.2022.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Codable {
    @DocumentID var uid = UUID().uuidString
    let firstName: String
    let lastName: String
    let email: String
    let imageID: String
    
    let favourites: [String]
}
