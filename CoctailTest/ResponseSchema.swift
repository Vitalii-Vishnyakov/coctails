//
//  ResponseSchema.swift
//  CoctailTest
//
//  Created by Виталий on 01.04.2022.
//

import Foundation
// MARK: - Coctail
struct Coctail: Codable {
    let drinks: [Drink]
}

// MARK: - Drink
struct Drink: Codable {
    let strDrink: String
    let strDrinkThumb: String
    let idDrink: String
}
