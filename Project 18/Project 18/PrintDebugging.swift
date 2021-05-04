//
//  ViewController.swift
//  Project 18
//
//  Created by Samuel Shi on 5/4/21.
//

import UIKit

class PrintViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("I'm inside the viewDidLoad() method")
    print("Some message", terminator: "")
    print(1, 2, 3, 4, 5, separator: "-")
  }
}

