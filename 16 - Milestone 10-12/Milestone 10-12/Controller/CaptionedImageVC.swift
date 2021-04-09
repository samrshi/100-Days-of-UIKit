//
//  DetailViewController.swift
//  Milestone 10-12
//
//  Created by Samuel Shi on 4/6/21.
//

import UIKit

class CaptionedImageVC: UIViewController {
  var captionLabel = UILabel()
  var pictureView  = UIImageView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground

    view.addSubview(captionLabel)
    view.addSubview(pictureView)
    
    configureCaptionLabel()
    configureImageView()
    setCaptionConstraints()
    setImageConstraints()
  }
  
  func set(image: CaptionedImage) {
    title = image.caption
    pictureView.image = ImageStore.image(for: image)
  }
  
  private func configureCaptionLabel() {
    captionLabel.textColor = .label
  }
  
  private func configureImageView() {
    pictureView.contentMode = .scaleAspectFit
  }
  
  private func setCaptionConstraints() {
    captionLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      captionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      captionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
  
  private func setImageConstraints() {
    pictureView.translatesAutoresizingMaskIntoConstraints = false
    pictureView.pin(to: view)
  }
}
