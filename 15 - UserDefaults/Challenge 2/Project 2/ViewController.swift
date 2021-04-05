//
//  ViewController.swift
//  Project 2
//
//  Created by Samuel Shi on 2/27/21.
//

import UIKit

extension String {
  static var highscoreKey = "highscore"
}

class ViewController: UIViewController {

  @IBOutlet var button1: UIButton!
  @IBOutlet var button2: UIButton!
  @IBOutlet var button3: UIButton!
  
  var countries = [String]()
  var score = 0
  var correctAnswer = 0
  var questionsAsked = 0
  var highscore = 0
  
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
    
    let defaults = UserDefaults.standard
    highscore = defaults.integer(forKey: .highscoreKey)
  }

  func askQuestion(action: UIAlertAction! = nil) {
    countries.shuffle()
    correctAnswer = Int.random(in: 0...2)
    
    button1.setImage(UIImage(named: countries[0]), for: .normal)
    button2.setImage(UIImage(named: countries[1]), for: .normal)
    button3.setImage(UIImage(named: countries[2]), for: .normal)
    
    title = countries[correctAnswer].uppercased() + ": \(score) points"
    questionsAsked += 1
  }
  
  @IBAction func buttonTapped(_ sender: UIButton) {
    var title: String
    let correct = sender.tag == correctAnswer
    
    if correct {
      title = "Correct"
      score += 1
      if score > highscore {
        let defaults = UserDefaults.standard
        defaults.setValue(score, forKey: .highscoreKey)
        highscore = score
        showNewHighscore()
      }
    } else {
      title = "Wrong"
      score -= 1
    }
    
    let countryGuessed = formattedNames[countries[sender.tag]]!
    
    var message: String
    if questionsAsked == 10 {
      message = "Game Over!\nYour final score was \(score)"
      score = 0
      questionsAsked = 0
    } else {
      message = correct ? "Good Job!" :
        "Wrong, that was the flag of \(countryGuessed)"
      
      message += "\nYour score is now \(score)."
    }
    
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Continue", style: .default, handler: askQuestion)
    ac.addAction(action)
    present(ac, animated: true)
  }
  
  @objc func scoreTapped() {
    let ac = UIAlertController(
      title: "Good job so far!",
      message: "Your current score is \(score)\nYour highscore is \(highscore)",
      preferredStyle: .alert
    )
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    ac.addAction(action)
    present(ac, animated: true)
  }
  
  func showNewHighscore() {
    let ac = UIAlertController(
      title: "New Highscore!",
      message: "\(highscore) is your new highscore.\nCongrats!",
      preferredStyle: .alert
    )
    ac.addAction(UIAlertAction(title: "OK", style: .default))
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
