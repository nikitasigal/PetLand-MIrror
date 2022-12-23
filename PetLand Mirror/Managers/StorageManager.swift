//
//  StorageManager.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 05.12.2022.
//

import FirebaseStorage
import UIKit

enum StorageError: Error {
    case corruptedData
}

protocol StorageManagerProtocol {
    func getImage(withID: String, _ completion: @escaping (Result<UIImage, Error>) -> Void)
}

class StorageManager {
    static let shared = StorageManager()

    private let storageRef = Storage.storage().reference()
}

extension StorageManager: StorageManagerProtocol {
    func getImage(withID imageID: String, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        storageRef.child("images").child(imageID).getData(maxSize: 5 * 1024 * 1024) { result in
            switch result {
            case let .success(data):
                guard let image = UIImage(data: data)
                else {
                    DispatchQueue.main.async { completion(.failure(StorageError.corruptedData)) }
                    return
                }
                DispatchQueue.main.async { completion(.success(image)) }
            case let .failure(error):
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
}
