//
//  ViewController.swift
//  Project 18
//
//  Created by Samuel Shi on 5/4/21.
//

import UIKit

class AssertViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    assert(1 == 1, "Math failure!")
    assert(1 == 2, "Math failure!")
    
    assert(myReallySlowMethod() == true, "The slow method returned false, which is a bad thing")
  }
  
  func myReallySlowMethod() -> Bool {
    var sum = 0
    for i in 1 ..< 1000 {
      sum += i
    }
    return sum == 500500
  }
}

