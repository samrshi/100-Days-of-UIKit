//
//  CollectionViewController.swift
//  Project1
//
//  Created by Samuel Shi on 3/28/21.
//

import UIKit

private let reuseIdentifier = "Image Cell"

class CollectionViewController: UICollectionViewController {
  var pictures = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Storm Viewer"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    
    for item in items.sorted() {
      print(item)
      if item.hasPrefix("nssl") {
        // this is a picture to load!
        pictures.append(item)
      }
    }
  }
  
  @objc func shareTapped() {
    let message = "Check out StormViewer on the appstore! https://www.apple.com/StormViewer"
    let vc = UIActivityViewController(activityItems: [message], applicationActivities: [])
    vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(vc, animated: true)
  }
  
  override func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return pictures.count
  }
  
  override func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: reuseIdentifier, for: indexPath
    ) as! ImageCell
    
    let image = pictures[indexPath.item]
    cell.name.text = image
    cell.image.image = UIImage(named: image)
    
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
      vc.selectedImage = pictures[indexPath.row]
      vc.title = "Picture \(indexPath.row + 1) of \(pictures.count)"
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}
