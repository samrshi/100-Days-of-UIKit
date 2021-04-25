//
//  CountryTableViewCell.swift
//  Milestone 13-15
//
//  Created by Samuel Shi on 4/25/21.
//

import UIKit

class CountryCell: UITableViewCell {
  static let reuseID = "CountryTableViewCell"
  
  var nameLabel = UILabel()
  var flagImage = UIImageView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    accessoryType = .disclosureIndicator
    addSubview(nameLabel)
    addSubview(flagImage)
    
    configureFlagImage()
    configureNameLabel()
    setFlagImageConstraints()
    setNameLabelConstraints()
  }
  
  func set(country: Country) {
    nameLabel.text = country.name
    flagImage.image = UIImage(named: country.alpha2Code)
  }
  
  func configureFlagImage() {
    flagImage.clipsToBounds = true
    flagImage.contentMode   = .scaleAspectFit
    flagImage.image         = UIImage(systemName: "flag")
  }
  
  func configureNameLabel() {
    nameLabel.numberOfLines = 10
  }
  
  func setFlagImageConstraints() {
    flagImage.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      flagImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      flagImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
      flagImage.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  func setNameLabelConstraints() {
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      nameLabel.leadingAnchor.constraint(equalTo: flagImage.trailingAnchor, constant: 12),
      nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
      nameLabel.centerYAnchor.constraint(equalTo: flagImage.centerYAnchor)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
