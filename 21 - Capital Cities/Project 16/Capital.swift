//
//  Capital.swift
//  Project 16
//
//  Created by Samuel Shi on 4/27/21.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
  var title: String?
  var coordinate: CLLocationCoordinate2D
  var info: String
  var url: URL
  
  init(
    title: String,
    urlName: String? = nil,
    coordinate: CLLocationCoordinate2D,
    info: String
  ) {
    self.title = title
    self.coordinate = coordinate
    self.info = info
    
    let urlName = urlName == nil ? title : urlName!
    let urlString = "https://wikipedia.com/wiki/\(urlName)"
    
    url = URL(string: urlString)!
  }
}
