//
//  DetailViewController.swift
//  Milestone 1
//
//  Created by Samuel Shi on 3/5/21.
//

import UIKit

class DetailViewController: UIViewController {
  @IBOutlet var imageView: UIImageView!
  var selectedImage: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let imageToLoad = selectedImage {
      imageView.image = UIImage(named: imageToLoad)
      imageView.layer.borderColor = UIColor.black.cgColor
      imageView.layer.borderWidth = 0.2
      
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    navigationItem.largeTitleDisplayMode = .never
  }
  
  @objc func shareTapped() {
    guard let image = imageView.image?.jpegData(compressionQuality: 0.8), let name = title else {
      print("No image found")
      return
    }
    
    let vc = UIActivityViewController(activityItems: [image, name], applicationActivities: [])
    vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(vc, animated: true)
  }
}
