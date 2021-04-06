//
//  ViewController.swift
//  Milestone 10-12
//
//  Created by Samuel Shi on 4/6/21.
//

import UIKit

extension String {
  static var imagesKey = "images"
  static var imageRowID = "imageRowCell"
}

class ViewController: UITableViewController {
  var images: [CaptionedImage] = [] {
    didSet { save() }
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    title = "ViewController"
    
    makeNavigationButtons()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: .imageRowID)
  }
  
  func makeNavigationButtons() {
    let addButton = UIBarButtonItem(
      barButtonSystemItem: .add,
      target: self,
      action: #selector(addNewImage)
    )
    navigationItem.leftBarButtonItem = addButton
  }
  
  @objc func addNewImage() {
    guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
      print("No camera available")
      return
    }
    
    let picker = UIImagePickerController()
    picker.sourceType = .camera
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }
  
  func save() {
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    
    if let data = try? encoder.encode(images) {
      defaults.setValue(data, forKey: .imagesKey)
    }
  }
  
  func showCaptionAlert(image: CaptionedImage) {
    let ac = UIAlertController(title: "Caption Image", message: nil, preferredStyle: .alert)
    ac.addTextField()
    let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak image, weak ac] _ in
      guard let self = self, let image = image, let text = ac?.textFields?[0].text else { return }
      self.submitCaption(for: image, text: text)
    }
    ac.addAction(submitAction)
    self.present(ac, animated: true)
  }
  
  func submitCaption(for image: CaptionedImage, text: String) {
    image.caption = text
    self.tableView.reloadData()
  }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }
    
    let imageName = UUID().uuidString
    let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
    
    if let jpegData = image.jpegData(compressionQuality: 0.8) {
      try? jpegData.write(to: imagePath)
    }
    
    let captionedImage = CaptionedImage(imageFilename: imagePath, caption: "")
    images.append(captionedImage)
    
    dismiss(animated: true)
    
    showCaptionAlert(image: captionedImage)
  }
  
  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    images.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: .imageRowID, for: indexPath)
    cell.textLabel?.text = images[indexPath.row].caption
    return cell
  }
}

