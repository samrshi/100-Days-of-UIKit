//
//  UIView+pin.swift
//  MIlestone 13-15
//
//  Created by Samuel Shi on 4/24/21.
//

import UIKit

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
