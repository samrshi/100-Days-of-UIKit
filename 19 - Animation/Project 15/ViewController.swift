//
//  ViewController.swift
//  Project 15
//
//  Created by Samuel Shi on 4/21/21.
//

import UIKit

class ViewController: UIViewController {
  var imageView: UIImageView!
  var currentAnimation = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imageView = UIImageView(image: UIImage(named: "penguin"))
    view.addSubview(imageView)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }

  @IBAction func tapped(_ sender: UIButton) {
    sender.isHidden = true
    
//    UIView.animate(
//      withDuration: 1,
//      delay: 0,
//      options: [],
//      animations: {
    UIView.animate(
      withDuration: 1,
      delay: 0,
      usingSpringWithDamping: 0.5,
      initialSpringVelocity: 0.5,
      options: [],
      animations: {
        switch self.currentAnimation {
        case 0:
          self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
        case 1:
          self.imageView.transform = .identity
        case 2:
          self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
        case 3:
          self.imageView.transform = .identity
        case 4:
          self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
        case 5:
          self.imageView.transform = .identity
        case 6:
          self.imageView.alpha = 0.1
          self.imageView.backgroundColor = .green
        case 7:
          self.imageView.alpha = 1
          self.imageView.backgroundColor = .clear
        default:
          break
        }
      },
      completion: { finished in
        sender.isHidden = false
      }
    )
    
    currentAnimation += 1
    
    if currentAnimation > 7 {
      currentAnimation = 0
    }
  }
}
