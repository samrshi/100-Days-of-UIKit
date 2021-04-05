//
//  DetailViewController.swift
//  Project1
//
//  Created by Samuel Shi on 2/7/21.
//

import UIKit

class DetailViewController: UIViewController {
  @IBOutlet var imageView: UIImageView!
  var selectedImage: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = selectedImage
    navigationItem.largeTitleDisplayMode = .never
        
    if let imageToLoad = selectedImage {
      imageView.image = UIImage(named: imageToLoad)
      
      let defaults = UserDefaults.standard
      let views = defaults.integer(forKey: imageToLoad)
      
      let word = views == 1 ? "view" : "views"
      let viewsButton = UIBarButtonItem(
        title: "\(views) \(word)",
        style: .plain,
        target: nil,
        action: nil
      )
      viewsButton.tintColor = .label
      
      navigationItem.rightBarButtonItem = viewsButton
      defaults.set(views + 1, forKey: imageToLoad)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.hidesBarsOnTap = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.hidesBarsOnTap = false
  }
}
