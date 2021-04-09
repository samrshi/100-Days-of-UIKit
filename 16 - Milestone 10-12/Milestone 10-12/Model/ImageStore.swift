//
//  ImageStore.swift
//  Milestone 10-12
//
//  Created by Samuel Shi on 4/8/21.
//

import UIKit

class ImageStore {
  static var imagesKey = "images"
  
  var images: [CaptionedImage] = [] {
    didSet { save() }
  }
  
  init() {
    if let images = getImagesFromDefaults() {
      self.images = images
    } else {
      self.images = []
    }
  }
  
  func getImagesFromDefaults() -> [CaptionedImage]? {
    let defaults = UserDefaults.standard
    let decoder = JSONDecoder()
    
    guard let data = defaults.data(forKey: ImageStore.imagesKey) else { return nil }
    let images = try? decoder.decode([CaptionedImage].self, from: data)
    return images
  }
  
  func save() {
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    
    if let data = try? encoder.encode(images) {
      defaults.setValue(data, forKey: ImageStore.imagesKey)
    }
  }
  
  func makeNewImage(for info: [UIImagePickerController.InfoKey : Any]) -> CaptionedImage {
    let image = info[.editedImage] as? UIImage
    
    let imageName = UUID().uuidString
    let imagePath = FileManager
      .getDocumentsDirectory()
      .appendingPathComponent(imageName)
    
    if let jpegData = image?.jpegData(compressionQuality: 0.8) {
      try? jpegData.write(to: imagePath)
    }
    
    let captionedImage = CaptionedImage(imageFilename: imageName, caption: "")
    images.append(captionedImage)
    return captionedImage
  }
  
  static func image(for image: CaptionedImage) -> UIImage? {
    let path = FileManager.getDocumentsDirectory().appendingPathComponent(image.imageFilename)
    return UIImage(contentsOfFile: path.path)
  }
}
