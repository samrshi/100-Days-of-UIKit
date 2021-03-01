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
