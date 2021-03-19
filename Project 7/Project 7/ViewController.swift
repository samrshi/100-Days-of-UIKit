//
//  ViewController.swift
//  Project 7
//
//  Created by Samuel Shi on 3/17/21.
//

import UIKit

class ViewController: UITableViewController {
  var petitions = [Petition]()
  var filteredPetitions = [Petition]()
  
  enum ButtonType {
    case credits, filter, clearFilter
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = makeButton(buttonType: .credits)
    navigationItem.leftBarButtonItem = makeButton(buttonType: .filter)
    
    let urlString: String
    if navigationController?.tabBarItem.tag == 0 {
      urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
    } else {
      urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
    }
    
    if let url = URL(string: urlString) {
      if let data = try? Data(contentsOf: url) {
        parse(json: data)
        return
      }
    }
    showError()
  }
  
  // challenge 2
  @objc func search() {
    let ac = UIAlertController(title: "Filter Results", message: nil, preferredStyle: .alert)
    
    ac.addTextField()
    ac.addAction(UIAlertAction(title: "Filter", style: .default) { [weak self, weak ac] _ in
      guard let filterKey = ac?.textFields?[0].text?.lowercased() else { return }
      if filterKey.isEmpty { return }
      self?.submitFilter(key: filterKey)
    })
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(ac, animated: true)
    navigationItem.leftBarButtonItem = makeButton(buttonType: .clearFilter)
  }
  
  func submitFilter(key: String) {
    filteredPetitions = petitions.filter { petition in
      return petition.body.lowercased().contains(key) ||
        petition.title.lowercased().contains(key)
    }
    tableView.reloadData()
  }
  
  @objc func clearFilter() {
    self.filteredPetitions = petitions
    tableView.reloadData()
    navigationItem.leftBarButtonItem = makeButton(buttonType: .filter)
  }
  
  // challenge 1
  @objc func showCredits() {
    let ac = UIAlertController(title: "Credits", message: "This data comes fromthe We The Pepople API of the Whitehouse", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }
  
  func showError() {
    let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }
  
  func parse(json: Data) {
    let decoder = JSONDecoder()
    
    if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
      petitions = jsonPetitions.results
      filteredPetitions = petitions
      tableView.reloadData()
    }
  }
  
  func makeButton(buttonType: ButtonType) -> UIBarButtonItem {
    let button: UIBarButtonItem
    switch buttonType {
    case .credits:
      button = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
    case .filter:
      button = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
    case .clearFilter:
      button = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(clearFilter))
    }
    return button
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredPetitions.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let petition = filteredPetitions[indexPath.row]
    cell.textLabel?.text = petition.title
    cell.detailTextLabel?.text = petition.body
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = DetailViewController()
    vc.detailItem = filteredPetitions[indexPath.row]
    navigationController?.pushViewController(vc, animated: true)
  }
}

