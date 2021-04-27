//
//  ViewController.swift
//  Project 16
//
//  Created by Samuel Shi on 4/26/21.
//

import MapKit
import UIKit

class ViewController: UIViewController {
  let mapTypes: [String: MKMapType] = [
    "Hybrid": .hybrid,
    "Hybrid Flyover": .hybridFlyover,
    "Muted Standard": .mutedStandard,
    "Satellite": .satellite,
    "Satellite Flyover": .satelliteFlyover,
    "Standard": .standard
  ]
  
  @IBOutlet var mapView: MKMapView!
  var capital: Capital?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "MapKit"
    
    askForMapType()
    addAnnotations()
    makeBarButton()
  }
  
  func makeBarButton() {
    let button = UIBarButtonItem(
      title: "Map Type",
      style: .plain,
      target: self,
      action: #selector(askForMapType))
    navigationItem.rightBarButtonItem = button
  }
  
  @objc func askForMapType() { // challenge 2
    let ac = UIAlertController(
      title: "Choose a map type",
      message: nil,
      preferredStyle: .actionSheet)
    
    for typeName in mapTypes.keys {
      let action = UIAlertAction(
        title: typeName,
        style: .default
      ) { [weak self] (action) in
        guard
          let self  = self,
          let title = action.title,
          let type  = self.mapTypes[title]
        else { return }
        
        self.mapView.mapType = type
      }
      ac.addAction(action)
    }
    
    let cancel = UIAlertAction(title: "Cancel", style: .cancel)
    ac.addAction(cancel)
    
    present(ac, animated: true)
  }
  
  func addAnnotations() {
    let london = Capital(
      title: "London",
      coordinate: .init(latitude: 51.507222, longitude: -0.1275),
      info: "Home to the 2012 Summer Olympics.")
    
    let oslo = Capital(
      title: "Oslo",
      coordinate: .init(latitude: 59.95, longitude: 10.75),
      info: "Founded over a thousand years ago.")
    
    let paris = Capital(
      title: "Paris",
      coordinate: .init(latitude: 48.8567, longitude: 2.3508),
      info: "Often called the City of Light.")
    
    let rome = Capital(
      title: "Rome",
      coordinate: .init(latitude: 41.9, longitude: 12.5),
      info: "Has a whole country inside it.")
    
    let washington = Capital(
      title: "Washington",
      coordinate: .init(latitude: 38.895111, longitude: -77.036667),
      info: "Named after George himself.")
    
    mapView.addAnnotations([london, oslo, paris, rome, washington])
  }
}

extension ViewController: MKMapViewDelegate {
  func mapView(
    _ mapView: MKMapView,
    viewFor annotation: MKAnnotation
) -> MKAnnotationView? {
    guard annotation is Capital else { return nil }
    
    let id = "Capital"
    var annotationView = mapView.dequeueReusableAnnotationView(
      withIdentifier: id) as? MKPinAnnotationView // challenge 1
    
    if annotationView == nil {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
      annotationView?.canShowCallout = true
      annotationView?.tintColor = .magenta
      
      let btn = UIButton(type: .detailDisclosure)
      annotationView?.rightCalloutAccessoryView = btn
    } else {
      annotationView?.annotation = annotation
    }
    
    return annotationView
  }
  
  func mapView(
    _ mapView: MKMapView,
    annotationView view: MKAnnotationView,
    calloutAccessoryControlTapped control: UIControl
  ) {
    guard let capital = view.annotation as? Capital else { return }
    self.capital = capital
    
    let placeName = capital.title
    let placeInfo = capital.info
    
    let ac = UIAlertController(
      title: placeName,
      message: placeInfo,
      preferredStyle: .alert)
    
    let wikiAction = UIAlertAction(
      title: "Open Wikipedia",
      style: .default,
      handler: presentWebVC)
    ac.addAction(wikiAction)
    
    let okAction = UIAlertAction(
      title: "Cancel",
      style: .cancel)
    ac.addAction(okAction)
    
    present(ac, animated: true)
  }
  
  func presentWebVC(_: UIAlertAction) { // challenge 3
    guard let capital = capital else { return }
    
    let vc = WebViewController()
    vc.website = capital.url
    navigationController?.pushViewController(vc, animated: true)
  }
}

