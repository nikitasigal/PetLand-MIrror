//
//  RegexExtension.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 21.11.2022.
//

import Foundation

extension Regex {
    func match(in input: String) -> Bool {
        if let _ = try! wholeMatch(in: input) {
            return true
        } else {
            return false
        }
    }
}
