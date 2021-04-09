//
//  ImageModel.swift
//  Milestone 10-12
//
//  Created by Samuel Shi on 4/6/21.
//

import Foundation

class CaptionedImage: Codable {
  let imageFilename: String
  var caption: String
  
  init(imageFilename: String, caption: String) {
    self.imageFilename = imageFilename
    self.caption = caption
  }
}
