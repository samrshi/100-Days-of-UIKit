//
//  Person.swift
//  Project 10
//
//  Created by Samuel Shi on 3/28/21.
//

import UIKit

class Person: NSObject, Codable {
  var name: String
  var image: String
  
  init(name: String, image: String) {
    self.name = name
    self.image = image
  }
}
