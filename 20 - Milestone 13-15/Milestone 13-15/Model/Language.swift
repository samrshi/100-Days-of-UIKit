//
//  Language.swift
//  Milestone 13-15
//
//  Created by Samuel Shi on 4/25/21.
//

import Foundation

// MARK: - Language
struct Language: Codable {
  let iso6391: String?
  let iso6392: String
  let name: String
  let nativeName: String

  enum CodingKeys: String, CodingKey {
    case iso6391 = "iso639_1"
    case iso6392 = "iso639_2"
    case name, nativeName
  }
}
