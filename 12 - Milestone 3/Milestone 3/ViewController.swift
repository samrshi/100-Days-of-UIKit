//
//  ViewController.swift
//  Milestone 3
//
//  Created by Samuel Shi on 3/25/21.
//

import UIKit

class ViewController: UIViewController {
  var allWords = [String]()
  var usedLetters = [String]()
  var incorrectGuesses: Int = 0 {
    didSet {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.image.image = UIImage(named: "hangman\(self.incorrectGuesses)")
      }
    }
  }
  
  var currentWordIndex: Int = 0 {
    didSet {
      startLevel()
    }
  }
  
  var wordsGuessedCorrectly: Int = 0
  
  var promptLabel: UILabel!
  var textField: UITextField!
  var nextButton: UIButton!
  var wordLabel: UILabel!
  var image: UIImageView!
  
  var letterButtons = [UIButton]()
  var lettersRowOne: UIView!
  var lettersRowTwo: UIView!
  var lettersRowThree: UIView!
  var lettersRowFour: UIView!
  
  let letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
  
  override func loadView() {
    view = UIView()
    view.backgroundColor = .black
    
    promptLabel = UILabel()
    promptLabel.translatesAutoresizingMaskIntoConstraints = false
    promptLabel.font = .monospacedSystemFont(ofSize: 35, weight: .bold)
    promptLabel.text = "Hello"
    promptLabel.textColor = .white
    view.addSubview(promptLabel)
    
    image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.image = UIImage(named: "hangman0")
    image.contentMode = .scaleAspectFit
    view.addSubview(image)
    
    lettersRowOne = UIView()
    lettersRowOne.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(lettersRowOne)

    lettersRowTwo = UIView()
    lettersRowTwo.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(lettersRowTwo)

    lettersRowThree = UIView()
    lettersRowThree.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(lettersRowThree)

    lettersRowFour = UIView()
    lettersRowFour.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(lettersRowFour)
    
    let rowHeight: CGFloat = 0.5*0.22
    
    NSLayoutConstraint.activate([
      image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
      image.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      image.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      image.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      image.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3),
      
      promptLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 40),
      promptLabel.centerXAnchor.constraint(equalTo: image.centerXAnchor),

      lettersRowOne.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
      lettersRowOne.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: rowHeight),

      lettersRowTwo.topAnchor.constraint(equalTo: lettersRowOne.bottomAnchor),
      lettersRowTwo.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
      lettersRowTwo.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: rowHeight),

      lettersRowThree.topAnchor.constraint(equalTo: lettersRowTwo.bottomAnchor),
      lettersRowThree.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
      lettersRowThree.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: rowHeight),

      lettersRowFour.topAnchor.constraint(equalTo: lettersRowThree.bottomAnchor),
      lettersRowFour.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
      lettersRowFour.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: rowHeight),
      lettersRowFour.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    overrideUserInterfaceStyle = .dark
    performSelector(inBackground: #selector(parseWords), with: nil)
    
    navigationController?.navigationBar.prefersLargeTitles = true
    title = "Hangman"
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(showScore))
    
    addButtonsRow(startingPosition: 0, maxCol: 6, view: lettersRowOne)
    addButtonsRow(startingPosition: 6, maxCol: 7, view: lettersRowTwo)
    addButtonsRow(startingPosition: 13, maxCol: 6, view: lettersRowThree)
    addButtonsRow(startingPosition: 19, maxCol: 7, view: lettersRowFour)
  }
  
  func addButtonsRow(startingPosition: Int, maxCol: Int, view: UIView) {
    for col in 0..<maxCol {
      let button = UIButton(type: .system)
      button.titleLabel?.font = .monospacedSystemFont(ofSize: 30, weight: .regular)
      button.setTitleColor(.white, for: .normal)
      button.setTitle(letters[startingPosition + col], for: .normal)
      button.contentHorizontalAlignment = .center
      button.contentVerticalAlignment = .center
      button.translatesAutoresizingMaskIntoConstraints = false
      button.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
      
      view.addSubview(button)
      
      button.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
      button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/CGFloat(maxCol)).isActive = true
      
      switch col {
      // leftmost button
      case 0:
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
      // rightmost button
      case maxCol - 1:
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        fallthrough
      // middle buttons
      default:
        button.leadingAnchor.constraint(greaterThanOrEqualTo: letterButtons[startingPosition + (col - 1)].trailingAnchor).isActive = true
      }
      
      letterButtons.append(button)
    }
  }
  
  @objc func letterTapped(_ sender: UIButton) {
    guard let text = sender.titleLabel?.text else { return }
    sender.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0.25), for: .normal)
    guessLetter(guess: text.lowercased())
  }
  
  @objc func showScore() {
    let ac = UIAlertController(title: "Your Score", message: "You have guessed \(incorrectGuesses) letters incorrectly.\nYou have guessed \(wordsGuessedCorrectly) words correctly.", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
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
    wordsGuessedCorrectly = 0
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
            self.wordsGuessedCorrectly += 1
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
      
      for button in self.letterButtons {
        button.setTitleColor(.white, for: .normal)
      }
    }
  }
}

