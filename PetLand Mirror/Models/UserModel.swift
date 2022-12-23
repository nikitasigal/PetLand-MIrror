//
//  UserModel.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 15.12.2022.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: FirestoreDocument {
    @DocumentID var uid = UUID().uuidString
    var imageID: String = "noavatar"
    let firstName: String
    let lastName: String
    let email: String
    
    let favourites: [String]
}
