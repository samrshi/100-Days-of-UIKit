//
//  ViewController.swift
//  Project 16
//
//  Created by Samuel Shi on 4/26/21.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
  @IBOutlet var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
  
  func mapView(
    _ mapView: MKMapView,
    viewFor annotation: MKAnnotation
) -> MKAnnotationView? {
    guard annotation is Capital else { return nil }
    
    let id = "Capital"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: id)
    
    if annotationView == nil {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
      annotationView?.canShowCallout = true
      
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
    
    let placeName = capital.title
    let placeInfo = capital.info
    
    let ac = UIAlertController(
      title: placeName,
      message: placeInfo,
      preferredStyle: .alert)
    
    let action = UIAlertAction(title: "OK", style: .default)
    ac.addAction(action)
    
    present(ac, animated: true)
  }
}

