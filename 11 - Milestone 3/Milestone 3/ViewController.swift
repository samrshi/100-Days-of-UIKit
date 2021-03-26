//
//  ViewController.swift
//  Milestone 3
//
//  Created by Samuel Shi on 3/25/21.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
  var allWords = [String]()
  var usedLetters = [String]()
  var incorrectGuesses: Int = 0 {
    didSet {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.triesLabel.text = "Incorrect Guesses: \(self.incorrectGuesses)"
        self.image.image = UIImage(named: "hangman\(self.incorrectGuesses)")
      }
    }
  }
  
  var currentWordIndex: Int = 0 {
    didSet {
      startLevel()
    }
  }
  
  var promptLabel: UILabel!
  var triesLabel: UILabel!
  var textField: UITextField!
  var nextButton: UIButton!
  var wordLabel: UILabel!
  var image: UIImageView!
  
  override func loadView() {
    view = UIView()
    view.backgroundColor = .black
    
    promptLabel = UILabel()
    promptLabel.translatesAutoresizingMaskIntoConstraints = false
    promptLabel.font = .monospacedSystemFont(ofSize: 35, weight: .bold)
    promptLabel.text = "Hello"
    promptLabel.textColor = .white
    view.addSubview(promptLabel)
    
    triesLabel = UILabel()
    triesLabel.translatesAutoresizingMaskIntoConstraints = false
    triesLabel.text = "Incorrect Guesses: 0"
    triesLabel.textColor = .white
    view.addSubview(triesLabel)
    
    image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.image = UIImage(named: "hangman0")
    image.contentMode = .scaleAspectFit
    view.addSubview(image)
    
    textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "Enter Guess"
    textField.textColor = .white
    textField.borderStyle = UITextField.BorderStyle.roundedRect
    textField.returnKeyType = .done
    textField.autocapitalizationType = .none
    textField.delegate = self
    textField.becomeFirstResponder()
    view.addSubview(textField)
    
    NSLayoutConstraint.activate([
      triesLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
      triesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
      image.topAnchor.constraint(equalTo: triesLabel.bottomAnchor, constant: 50),
      image.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      image.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      image.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      image.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3),
      promptLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 15),
      promptLabel.centerXAnchor.constraint(equalTo: image.centerXAnchor),
      textField.topAnchor.constraint(equalTo: promptLabel.bottomAnchor, constant: 15),
      textField.centerXAnchor.constraint(equalTo: promptLabel.centerXAnchor),
      textField.widthAnchor.constraint(equalTo: image.widthAnchor)
    ])
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    overrideUserInterfaceStyle = .dark
    performSelector(inBackground: #selector(parseWords), with: nil)
  }
  
  @objc func parseWords() {
    let path = Bundle.main.path(forResource: "hangman_words", ofType: "txt")!
    let url = URL(fileURLWithPath: path)
    if let data = try? String(contentsOf: url) {
      let wordsArray = data.components(separatedBy: "\n")
      allWords = wordsArray.shuffled()
    }
    allWords.removeAll { string in
      string == ""
    }
    currentWordIndex = 0
  }
  
  func startLevel() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      
      if self.currentWordIndex >= self.allWords.count {
        let ac = UIAlertController(title: "Game Over!", message: "That's all of the words we have for you.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Start Over", style: .default) { [weak self] _ in
          guard let self = self else { return }
          self.currentWordIndex = 0
          self.allWords.shuffle()
        })
        self.present(ac, animated: true)
        return
      }
      
      self.usedLetters = []
      self.incorrectGuesses = 0

      let currentWord = self.allWords[self.currentWordIndex].lowercased()
      var result: String = ""
      for _ in currentWord {
        result += "_"
      }
      self.promptLabel.text = result.trimmingCharacters(in: .whitespacesAndNewlines)
      }
  }
  
  func guessLetter(guess: String) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self, var prompt = self.promptLabel.text else { return }
      
      if self.usedLetters.contains(guess) {
        let ac = UIAlertController(title: "Try again.", message: "You already guessed that letter.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
        return
      }
      
      let currentWord = self.allWords[self.currentWordIndex].lowercased()
      self.usedLetters.append(guess)

      if currentWord.contains(guess) {
        for (index, char) in currentWord.enumerated() {
          if String(char) == guess {
            let idx = String.Index(utf16Offset: index, in: prompt)
            prompt.replaceSubrange(idx...idx, with: guess)
          }
        }
        self.promptLabel.text = prompt
        
        if prompt.lowercased() == currentWord.lowercased() {
          let ac = UIAlertController(title: "Congratulations!", message: "You completed the level!", preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "Next Level", style: .default) { _ in
            self.currentWordIndex += 1
          })
          self.present(ac, animated: true)
        }
      } else {
        self.incorrectGuesses += 1
        
        if self.incorrectGuesses == 7 {
          let ac = UIAlertController(title: "Too many incorrect guesses!", message: "The word was \(currentWord).", preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "Next Level", style: .default) { _ in
            self.currentWordIndex += 1
          })
          self.present(ac, animated: true)
        }
      }
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let text = textField.text {
      if text.count != 0 {
        guessLetter(guess: text.lowercased())
      }
    }
    textField.text = ""
    return true
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if ((textField.text?.count)! + (string.count - range.length)) > 1 {
      return false
    }
    return true
  }
}

