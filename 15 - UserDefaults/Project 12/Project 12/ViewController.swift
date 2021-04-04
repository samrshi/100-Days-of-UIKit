//
//  ViewController.swift
//  Project 12
//
//  Created by Samuel Shi on 4/3/21.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let defaults = UserDefaults.standard
    defaults.set(25, forKey: "age")
    defaults.set(true, forKey: "useFaceID")
    defaults.set(CGFloat.pi, forKey: "pi")
    
    defaults.set("Paul Hudson", forKey: "name")
    defaults.set(Date(), forKey: "lastRun")
    
    let array = ["Hello", "World"]
    defaults.set(array, forKey: "savedArray")
    
    let dict = ["Name" : "Paul", "Country" : "UK"]
    defaults.set(dict, forKey: "savedDict")
    
    // returns 0, false as default value if no value exists at that key
    let savedInteger = defaults.integer(forKey: "age")
    let savedBoolean = defaults.bool(forKey: "useFaceID")
    
    let savedArray = defaults.object(forKey: "savedArray") as? [String] ?? [String]()
    let savedDict = defaults.object(forKey: "savedDict") as? [String : String] ?? [String : String]()
    
    let savedArray2 = defaults.array
  }
}
