//
//  Country.swift
//  MIlestone 13-15
//
//  Created by Samuel Shi on 4/25/21.
//

import Foundation

// MARK: - Country
struct Country: Codable {
  let currencies: [Currency]
  let languages: [Language]
  let flag: String
  let name: String
  let alpha2Code: String
  let capital: String
  let population: Int
  let demonym: String
  let area: Double?
  let nativeName: String
}
