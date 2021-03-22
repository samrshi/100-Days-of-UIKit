//
//  ViewController.swift
//  Milestone 2
//
//  Created by Samuel Shi on 3/16/21.
//

import UIKit

class ViewController: UITableViewController {

  var shoppingList: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Shopping List"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
    let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    let clearButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clear))
    
    navigationItem.rightBarButtonItem = addButton
    navigationItem.leftBarButtonItems = [clearButton, shareButton]
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shoppingList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
    cell.textLabel?.text = shoppingList[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = shoppingList[indexPath.row]
    let ac = UIAlertController(title: "Are you sure?", message: "Do you want to remove \(item.lowercased()) from your shopping list?", preferredStyle: .alert)
    
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    ac.addAction(UIAlertAction(title: "Remove", style: .default) { [weak self] _ in
      self?.shoppingList.remove(at: indexPath.row)
      self?.tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    })
    
    present(ac, animated: true)
  }
  
  @objc func addItem() {
    let ac = UIAlertController(title: "Add a Grocery Item", message: "Add an item to your grocery list.", preferredStyle: .alert)
    ac.addTextField()
    ac.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
      guard let item = ac?.textFields?[0].text else { return }
      self?.submit(item: item)
    })
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    
    present(ac, animated: true)
  }
  
  func submit(item: String) {
    guard !item.isEmpty else { return }
    
    shoppingList.insert(item, at: 0)
    let indexPath = IndexPath(row: 0, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
  }
  
  @objc func clear() {
    if shoppingList.isEmpty { return }

    let ac = UIAlertController(title: "Are you sure?", message: "Are you sure that you want to clear your shopping list?", preferredStyle: .alert)
    
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    ac.addAction(UIAlertAction(title: "Clear", style: .default) { [weak self] _ in
      self?.shoppingList = []
      self?.tableView.reloadData()
    })
    
    present(ac, animated: true)
  }
  
  @objc func shareTapped() {
    if shoppingList.isEmpty { return }
    
    let items = shoppingList.joined(separator: "\n")
    let vc = UIActivityViewController(activityItems: [items], applicationActivities: [])
    vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(vc, animated: true)
  }
}

