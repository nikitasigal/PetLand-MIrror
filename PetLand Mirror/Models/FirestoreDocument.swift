//
//  FirestoreDocument.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 23.12.2022.
//
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol FirestoreDocument: Codable {
    var uid: String? { get set }
}
