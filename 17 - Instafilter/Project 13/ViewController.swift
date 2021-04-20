//
//  ViewController.swift
//  Project 13
//
//  Created by Samuel Shi on 4/15/21.
//

import CoreImage
import UIKit

class ViewController: UIViewController {
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var intensity: UISlider!
  @IBOutlet var radius: UISlider! // challenge 3
  @IBOutlet var changeFilter: UIButton!   // challenge 2

  
  var currentImage: UIImage!
  
  var context: CIContext!
  var currentFilter: CIFilter!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "InstaFilter"
    
    let importButton = UIBarButtonItem(
      barButtonSystemItem: .add,
      target: self,
      action: #selector(importPicture)
    )
    navigationItem.rightBarButtonItem = importButton
    
    context = CIContext()
    currentFilter = CIFilter(name: "CISepiaTone")
    changeFilter.setTitle("CISepiaTone", for: .normal)
  }
  
  @objc func importPicture() {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }
  
  @IBAction func changeFilter(_ sender: UIButton) {
    let ac = UIAlertController(
      title: "Choose Filter",
      message: nil,
      preferredStyle: .actionSheet
    )
    let bump = UIAlertAction(
      title: "CIBumpDistortion",
      style: .default,
      handler: setFilter
    )
    let blur = UIAlertAction(
      title: "CIGaussianBlur",
      style: .default,
      handler: setFilter
    )
    let pixellate = UIAlertAction(
      title: "CIPixellate",
      style: .default,
      handler: setFilter
    )
    let sepia = UIAlertAction(
      title: "CISepiaTone",
      style: .default,
      handler: setFilter
    )
    let twirl = UIAlertAction(
      title: "CITwirlDistortion",
      style: .default,
      handler: setFilter
    )
    let unsharpMask = UIAlertAction(
      title: "CIUnsharpMask",
      style: .default,
      handler: setFilter
    )
    let vignette = UIAlertAction(
      title: "CIVignette",
      style: .default,
      handler: setFilter
    )
    let cancel = UIAlertAction(title: "Cancel", style: .cancel)
    
    ac.addAction(bump)
    ac.addAction(blur)
    ac.addAction(pixellate)
    ac.addAction(sepia)
    ac.addAction(twirl)
    ac.addAction(unsharpMask)
    ac.addAction(vignette)
    ac.addAction(cancel)
    
    if let popoverController = ac.popoverPresentationController {
      popoverController.sourceView = sender
      popoverController.sourceRect = sender.bounds
    }
    
    present(ac, animated: true)
  }
  
  func setFilter(action: UIAlertAction) {
    guard currentImage != nil else { return }
    guard let actionTitle = action.title else { return }
    
    currentFilter = CIFilter(name: actionTitle)
    changeFilter.setTitle(actionTitle, for: .normal)
    
    let beginImage = CIImage(image: currentImage)
    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
    
    applyProcessing()
  }
  
  @IBAction func save(_ sender: Any) {
    guard let image = imageView.image else {
      // challenge 1
      let ac = UIAlertController(
        title: "Save Error",
        message: "You must select an image before saving.",
        preferredStyle: .alert
      )
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
      
      return
    }
    
    UIImageWriteToSavedPhotosAlbum(
      image,
      self,
      #selector(image(_:didFinishSavingWithError:contextInfo:)),
      nil
    )
  }
  
  @objc func image(
    _ image: UIImage,
    didFinishSavingWithError error : Error?,
    contextInfo: UnsafeRawPointer
  ) {
    let ac = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))

    if let error = error {
      ac.title = "Save Error"
      ac.message = error.localizedDescription
    } else {
      ac.title = "Saved!"
      ac.message = "Your altered image has been saved to your photos."
    }
    
    present(ac, animated: true)
  }
  
  @IBAction func intensityChanged(_ sender: Any) {
    applyProcessing()
  }
  
  @IBAction func radiusChanged(_ sender: Any) {
    applyProcessing()
  }
  
  func applyProcessing() {
    let inputKeys = currentFilter.inputKeys
    
    if inputKeys.contains(kCIInputIntensityKey) {
      currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
    }
    
    if inputKeys.contains(kCIInputRadiusKey) {
      currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey)
    }
    
    if inputKeys.contains(kCIInputScaleKey) {
      currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
    }
    
    if inputKeys.contains(kCIInputCenterKey) {
      currentFilter.setValue(
        CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2),
        forKey: kCIInputCenterKey
      )
    }
    
    guard let outputImage = currentFilter.outputImage else { return }
    if let cgImage = context.createCGImage(outputImage,
      from: outputImage.extent
    ) {
      let processedImage = UIImage(cgImage: cgImage)
      imageView.image = processedImage
    }
  }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
  ) {
    guard let image = info[.editedImage] as? UIImage else { return }
    dismiss(animated: true)
    currentImage = image
    
    let beginImage = CIImage(image: currentImage)
    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
    applyProcessing()
  }
}

