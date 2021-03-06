//
//  ViewController.swift
//  Project 5
//
//  Created by Samuel Shi on 3/8/21.
//

import UIKit

extension String {
  static var currentWordKey = "currentWord"
  static var usedWordsKey = "usedWords"
}

class ViewController: UITableViewController {
  var allWords = [String]()
  var usedWords = [String]() {
    didSet {
      let defaults = UserDefaults.standard
      defaults.setValue(usedWords, forKey: .usedWordsKey)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
    
    if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
      if let startWords = try? String(contentsOf: startWordsURL) {
        allWords = startWords.components(separatedBy: "\n")
      }
    }
    
    if allWords.isEmpty {
      allWords = ["silkworm"]
    }
    
    let defaults = UserDefaults.standard
    
    if let word = defaults.string(forKey: .currentWordKey),
       let usedWords = defaults.array(forKey: .usedWordsKey) as? [String] {
      title = word
      self.usedWords = usedWords
      tableView.reloadData()
    } else {
      startGame()
    }
  }
  
  @objc func startGame() {
    let defaults = UserDefaults.standard
    
    title = allWords.randomElement()
    defaults.setValue(title, forKey: .currentWordKey)

    usedWords.removeAll(keepingCapacity: true)
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return usedWords.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
    cell.textLabel?.text = usedWords[indexPath.row]
    return cell
  }
  
  @objc func promptForAnswer() {
    let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
    ac.addTextField()
    let submitAction = UIAlertAction(title: "Submit", style: .default) {
      [weak self, weak ac] _ in
      guard let answer = ac?.textFields?[0].text else { return }
      self?.submit(answer)
    }
    
    ac.addAction(submitAction)
    present(ac, animated: true)
  }
  
  func submit(_ answer: String) {
    let lowerAnswer = answer.lowercased()
    if longEnough(word: lowerAnswer) {
      if isPossible(word: lowerAnswer) {
        if isOriginal(word: lowerAnswer) {
          if isReal(word: lowerAnswer) {
            usedWords.insert(lowerAnswer, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            return
          } else {
            showErrorMessage(title: "Word not recognized", message: "You can't just make them up, you know!")
          }
        } else {
          showErrorMessage(title: "Word used already", message: "Be more original!")
        }
      } else {
        guard let title = title?.lowercased() else { return }
        showErrorMessage(title: "Word not possible", message: "You can't spell that word from \(title)")
      }
    } else {
      showErrorMessage(title: "Word is too short", message: "Choose a word with more than two letters!")
    }
  }
  
  func showErrorMessage(title: String, message: String) {
    let ac = UIAlertController(title: title, message:  message, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }
  
  func longEnough(word: String) -> Bool {
    return word.count >= 3
  }
  
  func isPossible(word: String) -> Bool {
    guard var tempWord = title?.lowercased() else {
      return false
    }
    
    for letter in word {
      if let position = tempWord.firstIndex(of: letter) {
        tempWord.remove(at: position)
      } else {
        return false
      }
    }
    return true
  }
  
  func isOriginal(word: String) -> Bool {
    return !usedWords.contains(word)
  }
  
  func isReal(word: String) -> Bool {
    let checker = UITextChecker()
    let range = NSRange(location: 0, length: word.utf16.count)
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
    return misspelledRange.location == NSNotFound
  }
}

