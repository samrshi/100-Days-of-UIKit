//
//  MyTableViewCell.swift
//  Milestone 10-12
//
//  Created by Samuel Shi on 4/8/21.
//

import UIKit

class ImageCell: UITableViewCell {
  static let reuseID = "MyTableViewCell"
  
  var pictureView  = UIImageView()
  var captionLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(pictureView)
    addSubview(captionLabel)
    
    configureImageView()
    configureTitleLabel()
    setImageConstraints()
    setTitleConstraints()
  }
  
  func set(image: CaptionedImage) {
    let path = FileManager.getDocumentsDirectory().appendingPathComponent(image.imageFilename)
    let img = UIImage(contentsOfFile: path.path)
    
    pictureView.image = img
    captionLabel.text = image.caption
  }
  
  private func configureImageView() {
    pictureView.layer.cornerRadius = 10
    pictureView.clipsToBounds      = true
    pictureView.contentMode        = .scaleToFill
  }
  
  private func configureTitleLabel() {
    captionLabel.numberOfLines = 0
    captionLabel.adjustsFontSizeToFitWidth = true
  }
  
  private func setImageConstraints() {
    pictureView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      pictureView.centerYAnchor.constraint(equalTo: centerYAnchor),
      pictureView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
      pictureView.heightAnchor.constraint(equalToConstant: 80),
      pictureView.widthAnchor.constraint(equalTo: pictureView.heightAnchor)
    ])
  }
  
  private func setTitleConstraints() {
    captionLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      captionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      captionLabel.leadingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: 20),
      captionLabel.heightAnchor.constraint(equalToConstant: 80),
      captionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
