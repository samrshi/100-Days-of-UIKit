//
//  ViewController.swift
//  Project 2
//
//  Created by Samuel Shi on 2/27/21.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet var button1: UIButton!
  @IBOutlet var button2: UIButton!
  @IBOutlet var button3: UIButton!
  
  var countries = [String]()
  var score = 0
  var correctAnswer = 0
  var questionsAsked = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    countries += [
      "estonia", "france", "germany", "ireland",
      "italy", "monaco", "nigeria", "poland",
      "russia", "spain", "uk", "us"
    ]
    
    button1.layer.borderWidth = 1
    button2.layer.borderWidth = 1
    button3.layer.borderWidth = 1
    
    button1.layer.borderColor = UIColor.lightGray.cgColor
    button2.layer.borderColor = UIColor.lightGray.cgColor
    button3.layer.borderColor = UIColor.lightGray.cgColor
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "See Score", style: .plain, target: self, action: #selector(scoreTapped))
      
    askQuestion()
  }

  func askQuestion(action: UIAlertAction! = nil) {
    countries.shuffle()
    correctAnswer = Int.random(in: 0...2)
    
    button1.setImage(UIImage(named: countries[0]), for: .normal)
    button2.setImage(UIImage(named: countries[1]), for: .normal)
    button3.setImage(UIImage(named: countries[2]), for: .normal)
    
    UIView.animate(withDuration: 0.25) { [weak self] in
      self?.button1.transform = CGAffineTransform(scaleX: 1, y: 1)
      self?.button2.transform = CGAffineTransform(scaleX: 1, y: 1)
      self?.button3.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    title = countries[correctAnswer].uppercased() + ": \(score) points"
    questionsAsked += 1
  }
  
  @IBAction func buttonTapped(_ sender: UIButton) {
    var title: String
    let correct = sender.tag == correctAnswer
    
    if correct {
      title = "Correct"
      score += 1
    } else {
      title = "Wrong"
      score -= 1
    }
    
    let countryGuessed = formattedNames[countries[sender.tag]]!
    
    var message: String
    if questionsAsked == 2 {
      message = "Game Over!\nYour final score was \(score)"
      score = 0
      questionsAsked = 0
    } else {
      message = correct ? "Good Job!" :
        "Wrong, that was the flag of \(countryGuessed)"
      
      message += "\nYour score is now \(score)."
    }
    
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: 0.5,
      initialSpringVelocity: 0.5,
      options: []) {
      sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }
    
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Continue", style: .default, handler: askQuestion)
    ac.addAction(action)
    present(ac, animated: true)
  }
  
  @objc func scoreTapped() {
    let ac = UIAlertController(title: "Good job so far!", message: "Your current score is \(score)", preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    ac.addAction(action)
    present(ac, animated: true)
  }
}

let formattedNames: [String: String] = [
  "estonia": "Estonia",
  "france": "France",
  "germany": "Germany",
  "ireland": "Ireland",
  "italy": "Italy",
  "monaco": "Monaco",
  "nigeria": "Nigeria",
  "poland": "Poland",
  "russia": "Russia",
  "spain": "Spain",
  "uk": "the U.K.",
  "us": "the U.S.A."
]
