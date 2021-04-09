//
//  MyTableView.swift
//  Milestone 10-12
//
//  Created by Samuel Shi on 4/8/21.
//

import UIKit

class ImageListVC: UIViewController {
  
  var tableView = UITableView()
  let imageStore = ImageStore()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Your Images"
    configureTableView()
    makeNavigationBarButton()
  }
  
  func configureTableView() {
    view.addSubview(tableView)
    setTableViewDelegates()
    tableView.rowHeight = 100
    tableView.register(ImageCell.self, forCellReuseIdentifier: ImageCell.reuseID)
    tableView.pin(to: view)
  }
  
  func setTableViewDelegates() {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func makeNavigationBarButton() {
    let addButton = UIBarButtonItem(
      barButtonSystemItem: .add,
      target: self,
      action: #selector(showImagePicker)
    )
    navigationItem.rightBarButtonItem = addButton
  }
  
  @objc func showImagePicker() {
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
  
  func showCaptionAlert(image: CaptionedImage) {
    let ac = UIAlertController(
      title: "Caption Image",
      message: nil,
      preferredStyle: .alert
    )
    ac.addTextField()
    
    let submitAction = UIAlertAction(
      title: "Submit",
      style: .default
    ) { [weak self, weak image, weak ac] _ in
      guard let self = self, let image = image, let text = ac?.textFields?[0].text else { return }
      self.submitCaption(for: image, text: text)
    }
    
    ac.addAction(submitAction)
    self.present(ac, animated: true)
  }
  
  func submitCaption(for image: CaptionedImage, text: String) {
    image.caption = text
    tableView.reloadData()
    imageStore.save()
  }
}

extension ImageListVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return imageStore.images.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.reuseID) as! ImageCell
    let image = imageStore.images[indexPath.row]
    cell.set(image: image)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let detail = CaptionedImageVC()
    detail.set(image: imageStore.images[indexPath.row])
    tableView.deselectRow(at: indexPath, animated: true)
    
    navigationController?.pushViewController(detail, animated: true)
  }
  
  func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    if editingStyle == .delete {
      imageStore.images.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
}

extension ImageListVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
  ) {
    let image = imageStore.makeNewImage(for: info)
    tableView.reloadData()
    dismiss(animated: true)
    showCaptionAlert(image: image)
  }
}
