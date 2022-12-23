//
//  CurrencyFormatter.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 05.12.2022.
//

import Foundation

func formatCurrencyRU(input: Int) -> String? {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "ru_RU")
    formatter.numberStyle = .currency
    formatter.currencyCode = "RUB"
    formatter.maximumFractionDigits = 0

    return formatter.string(from: input as NSNumber)
}
