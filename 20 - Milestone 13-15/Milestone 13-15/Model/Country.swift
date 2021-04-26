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

struct CountryVM {
  let country: Country
  let formatter = NumberFormatter()
  
  init(country: Country) {
    self.country = country
    formatter.numberStyle = .decimal
  }
  
  var alpha2Code: String { country.alpha2Code }
  var languages: [Language] { country.languages }
  var currencies: [Currency] { country.currencies }
  
  func name() -> String {
    "Name: \(country.name)"
  }
  
  func demonym() -> String {
    "Demonym: \(country.demonym)"
  }
  
  func capital() -> String {
    "Capital: \(country.capital)"
  }
  
  func population() -> String {
    let number = formatter.string(for: country.population)!
    return "Population: \(number)"
  }
  
  func area() -> String {
    "Area: \(formatter.string(for: country.area)!) km²"
  }
  
  func langauge(index: Int) -> String {
    let language = country.languages[index]
    return "\(language.name) (\(language.nativeName))"
  }
  
  func currency(index: Int) -> String {
    let currency = country.currencies[index]
    let name = currency.name ?? "Unknown Name"
    let code = currency.code ?? "Unknown Code"
    let symbol = currency.symbol ?? "Unknown symbol"
    return "\(name) (\(code), \(symbol))"
  }
  
  func overview() -> String {
    var result = """
    General Information:
    - \(name())
    - \(demonym())
    - \(capital())
    - \(population())
    - \(area())
    Languages:
    """
    for i in languages.indices {
      result += "\n- \(langauge(index: i))"
    }
    result += "\nCurrencies"
    for i in currencies.indices {
      result += "\n- \(currency(index: i))"
    }
    return result
  }
}
