//
//  ViewController.swift
//  Project 10
//
//  Created by Samuel Shi on 3/27/21.
//

import UIKit

class ViewController: UICollectionViewController {
  var people = [Person]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .add,
      target: self,
      action: #selector(addNewPerson)
    )
    
    let defaults = UserDefaults.standard
    if let savedPeople = defaults.object(forKey: "people") as? Data {
      if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] {
        people = decodedPeople
      }
    }
  }
  
  func showNameAlert(person: Person) {
    let ac = UIAlertController(
      title: "Enter this person's name.",
      message: nil,
      preferredStyle: .alert
    )
    ac.addTextField()
    
    let submitAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
      guard let self = self, let ac = ac else { return }
      guard let text = ac.textFields?[0].text else { return }
      person.name = text
      self.save()
      self.collectionView.reloadData()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    ac.addAction(submitAction)
    ac.addAction(cancelAction)
    
    present(ac, animated: true)
  }
  
  @objc func addNewPerson() {
    // challenge 2
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      let ac = UIAlertController(
        title: "Choose Image",
        message: nil,
        preferredStyle: .actionSheet
      )
      let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
        self?.openCamera()
      }
      let galleryAction = UIAlertAction(title: "Photo Gallery", style: .default) {
        [weak self] _ in
        self?.openGallery()
      }
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
      ac.addAction(cameraAction)
      ac.addAction(galleryAction)
      ac.addAction(cancelAction)
      
      present(ac, animated: true)
      return
    }
    openGallery()
  }
  
  func openCamera() {
    let picker = UIImagePickerController()
    picker.sourceType = .camera
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }
  
  func openGallery() {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }

  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
}

extension ViewController {
  override func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return people.count
  }
  
  override func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "Person",
      for: indexPath
    ) as? PersonCell else {
      fatalError("Unable to dequeue PersonCell.")
    }
    
    let person = people[indexPath.item]
    cell.name.text = person.name
    
    let path = getDocumentsDirectory().appendingPathComponent(person.image)
    cell.imageView.image = UIImage(contentsOfFile: path.path)
    
    cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
    cell.imageView.layer.borderWidth = 2
    cell.imageView.layer.cornerRadius = 3
    cell.layer.cornerRadius = 7
    
    return cell
  }
  
  override func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    // challenge 1
    let promptAlert = UIAlertController(title: "What would you like to do?", message: nil, preferredStyle: .actionSheet)
    let person = people[indexPath.item]
    
    let renameAction = UIAlertAction(
      title: "Rename this person",
      style: .default) { [weak self] _ in
      self?.showNameAlert(person: person)
    }
    let deleteAction = UIAlertAction(
      title: "Delete this person",
      style: .destructive) { [weak self] _ in
        self?.people.remove(at: indexPath.item)
        self?.save()
        self?.collectionView.reloadData()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    promptAlert.addAction(renameAction)
    promptAlert.addAction(deleteAction)
    promptAlert.addAction(cancelAction)
    
    present(promptAlert, animated: true)
  }
  
  func save() {
    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "people")
    }
  }
}

extension ViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
  ) {
    guard let image = info[.editedImage] as? UIImage else { return }
    
    let imageName = UUID().uuidString
    let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
    
    if let jpegData = image.jpegData(compressionQuality: 0.8) {
      try? jpegData.write(to: imagePath)
    }
    
    let person = Person(name: "unknown", image: imageName)
    people.append(person)
    save()
    collectionView.reloadData()
    
    dismiss(animated: true)
    
    showNameAlert(person: person)
  }
}
