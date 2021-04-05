//
//  ViewController.swift
//  Project1
//
//  Created by Samuel Shi on 2/6/21.
//

import UIKit

class ViewController: UITableViewController {
  var pictures = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Storm Viewer"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    
    for item in items.sorted() {
      print(item)
      if item.hasPrefix("nssl") {
        // this is a picture to load!
        pictures.append(item)
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
    cell.textLabel?.text = pictures[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
      vc.selectedImage = pictures[indexPath.row]
      vc.title = "Picture \(indexPath.row + 1) of \(pictures.count)"
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  @objc func shareTapped() {
    let message = "Check out StormViewer on the appstore! https://www.apple.com/StormViewer"
    let vc = UIActivityViewController(activityItems: [message], applicationActivities: [])
    vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(vc, animated: true)
  }
}

