//
//  MainTableViewController.swift
//  Project 4
//
//  Created by Samuel Shi on 3/6/21.
//

import UIKit

class MainTableViewController: UITableViewController {
  
  var websites = ["apple.com", "hackingwithswift.com"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Web Pages"
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return websites.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
    
    let index = indexPath.row
    cell.textLabel?.text = websites[index]
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let vc = storyboard?.instantiateViewController(identifier: "WebViewController") as? WebViewController {
      vc.selectedWebsite = websites[indexPath.row]
      vc.websites = websites
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}
