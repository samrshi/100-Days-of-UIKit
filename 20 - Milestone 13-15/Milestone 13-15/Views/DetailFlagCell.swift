//
//  DetailFlagCell.swift
//  Milestone 13-15
//
//  Created by Samuel Shi on 4/25/21.
//

import UIKit

class DetailFlagCell: UITableViewCell {
  static let reuseID = "DetailFlagCell"
  
  var flagImage = UIImageView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(flagImage)
    
    configureFlagImage()
    setFlagImageConstraints()
  }
  
  func configureFlagImage() {
    clipsToBounds = true
    flagImage.clipsToBounds = true
    flagImage.contentMode   = .scaleAspectFill
    flagImage.image         = UIImage(systemName: "flag")
  }
  
  func setFlagImageConstraints() {
    flagImage.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      flagImage.centerXAnchor.constraint(equalTo: centerXAnchor),
      flagImage.centerYAnchor.constraint(equalTo: centerYAnchor),
      flagImage.widthAnchor.constraint(equalTo: widthAnchor),
      heightAnchor.constraint(greaterThanOrEqualToConstant: 150)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
