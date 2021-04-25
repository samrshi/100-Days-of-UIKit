//
//  DetailTextCell.swift
//  Milestone 13-15
//
//  Created by Samuel Shi on 4/25/21.
//

import UIKit

class DetailTextCell: UITableViewCell {
  static let reuseID = "DetailTextCell"
  
  var infoLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(infoLabel)
    
    configureFlagImage()
    setFlagImageConstraints()
  }
  
  func set(with text: String) {
    infoLabel.text = text
  }
  
  func configureFlagImage() {
    infoLabel.numberOfLines = 0
  }
  
  func setFlagImageConstraints() {
    infoLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
      infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 12)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
