//
//  ViewController.swift
//  Milestone 1
//
//  Created by Samuel Shi on 3/4/21.
//

import UIKit

class ViewController: UITableViewController {
  var pictures = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path)
    
    for item in items.sorted() {
      if item.hasPrefix("flag-") {
        pictures.append(item)
      }
    }
    pictures.sort()
    
    title = "Country Flags"
    navigationController?.navigationBar.prefersLargeTitles = true
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    pictures.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath) as! FlagCell
    
    let image = pictures[indexPath.row]
    cell.flagImage.image = UIImage(named: image)
    cell.flagImage.layer.cornerRadius = 7
    cell.flagImage.layer.borderColor = UIColor.black.cgColor
    cell.flagImage.layer.borderWidth = 0.2
    
    let name = formattedNames[image]
    cell.flagTitle.text = name
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
      let image = pictures[indexPath.row]
      let name = formattedNames[image]
      vc.title = name
      vc.selectedImage = image
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}

let formattedNames: [String: String] = [
  "flag-estonia.png": "Estonia",
  "flag-france.png": "France",
  "flag-germany.png": "Germany",
  "flag-ireland.png": "Ireland",
  "flag-italy.png": "Italy",
  "flag-monaco.png": "Monaco",
  "flag-nigeria.png": "Nigeria",
  "flag-poland.png": "Poland",
  "flag-russia.png": "Russia",
  "flag-spain.png": "Spain",
  "flag-uk.png": "U.K.",
  "flag-us.png": "U.S.A."
]
