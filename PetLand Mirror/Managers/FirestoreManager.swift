//
//  FirestoreManager.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 04.12.2022.
//

import FirebaseFirestore

enum Collection: String {
    case pets
    case users
}

enum FirestoreError: Error {
    case mappingError
}

protocol FirestoreManagerProtocol {
    func getItems<T: FirestoreDocument>(from collection: Collection, as _: T.Type, _ completion: @escaping (Result<[T], Error>) -> Void)
    func getItem<T: FirestoreDocument>(from collection: Collection, withID documentID: String, as documentType: T.Type, _ completion: @escaping (Result<T, Error>) -> Void)
    func updateItem<T: Hashable>(in collection: Collection, withID documentID: String, for field: String, set newValue: T, _ completion: @escaping (Error?) -> Void)
    func addItem<T: FirestoreDocument>(_ item: T, to collection: Collection, _ completion: @escaping (Error?) -> Void)
}

final class FirestoreManager: FirestoreManagerProtocol {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()

    func getItems<T: FirestoreDocument>(from collection: Collection, as _: T.Type, _ completion: @escaping (Result<[T], Error>) -> Void) {
        db.collection(collection.rawValue).getDocuments { snapshot, error in
            guard error == nil else {
                DispatchQueue.main.async { completion(.failure(error!)) }
                return
            }

            guard let items = snapshot?.documents.compactMap({ document -> T? in
                try? document.data(as: T.self)
            }) else {
                DispatchQueue.main.async { completion(.failure(FirestoreError.mappingError)) }
                return
            }

            DispatchQueue.main.async {
                completion(.success(items))
            }
        }
    }

    func getItem<T: FirestoreDocument>(from collection: Collection, withID documentID: String, as documentType: T.Type, _ completion: @escaping (Result<T, Error>) -> Void) {
        db.collection(collection.rawValue)
            .document(documentID)
            .getDocument(as: documentType, completion: completion)
    }

    func updateItem<T: Hashable>(in collection: Collection, withID documentID: String, for field: String, set newValue: T, _ completion: @escaping (Error?) -> Void) {
        db.collection(collection.rawValue)
            .document(documentID)
            .updateData([field: newValue], completion: completion)
    }

    func addItem<T: FirestoreDocument>(_ item: T, to collection: Collection, _ completion: @escaping (Error?) -> Void) {
        guard let documentID = item.uid else { return }

        do {
            try db.collection(collection.rawValue).document(documentID).setData(from: item, completion: completion)
        } catch {
            completion(error)
        }
    }
}
