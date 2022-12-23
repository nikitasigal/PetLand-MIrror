//
//  StringExtenstion.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 14.12.2022.
//

extension String {
    func uppercasedFirst() -> String {
        return prefix(1).uppercased() + dropFirst()
    }

    mutating func uppercaseFirst() {
        self = self.uppercasedFirst()
    }
}
