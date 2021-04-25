//
//  CountryStore.swift
//  Milestone 13-15
//
//  Created by Samuel Shi on 4/25/21.
//

import Foundation

protocol CountryStoreDelegate: AnyObject {
  func didReceiveCountries()
}

class CountryStore {
  var countries = [Country]()
  var delegate: CountryStoreDelegate?
  
  init() {
    let url = URL(string: "https://restcountries.eu/rest/v2/all")!
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      if let error = error { fatalError(error.localizedDescription) }
      guard let data = data else { fatalError("No Data") }
      
      DispatchQueue.main.async {
        let decoder = JSONDecoder()
        
        if let countries = try? decoder.decode([Country].self, from: data) {
          self.countries = countries
          self.delegate?.didReceiveCountries()
        }
      }
    }.resume()
  }
}
