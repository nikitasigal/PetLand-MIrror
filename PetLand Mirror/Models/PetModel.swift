//
//  PetModel.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 04.12.2022.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Pet: FirestoreDocument {
    @DocumentID var uid = UUID().uuidString
    var imageID: String = UUID().uuidString + ".jpg"
    let name: String
    let species: Species
    let breed: String
    let description: String
    let price: Int
    
    enum Species: String, Codable, CaseIterable {
        case dog, cat, hamster, parrot
    }
}

extension Pet {
    static func dummy() -> Pet {
        Pet(imageID: "dog-1.jpg",
            name: "Floof",
            species: .dog,
            breed: "Fluffy Dog",
            description: "floof dog. soft. very floof.",
            price: 17500)
    }
}
