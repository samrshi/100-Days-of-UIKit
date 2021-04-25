//
//  UIView+pin.swift
//  Milestone 10-12
//
//  Created by Samuel Shi on 4/8/21.
//

import UIKit

extension UIView {
  
  func pin(to superView: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: superView.topAnchor),
      leadingAnchor.constraint(equalTo: superView.leadingAnchor),
      trailingAnchor.constraint(equalTo: superView.trailingAnchor),
      bottomAnchor.constraint(equalTo: superView.bottomAnchor)
    ])
  }
}
