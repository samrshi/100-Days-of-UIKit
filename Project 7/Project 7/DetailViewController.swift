//
//  DetailViewController.swift
//  Project 7
//
//  Created by Samuel Shi on 3/19/21.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
  var webView: WKWebView!
  var detailItem: Petition?
  
  override func loadView() {
    webView = WKWebView()
    view = webView
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // challenge 3
    var signatureText: String = ""
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    if let count = detailItem?.signatureCount {
      if let formattedCount = formatter.string(from: NSNumber(value: count)) {
        signatureText = "\(formattedCount) signature\(count == 1 ? "" : "s")"
      }
    }
    
    guard let detailItem = detailItem else { return }
    let html = """
    <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 125%; } </style>
      </head>
      <body>
        <h2>
          \(detailItem.title)
        </h2>
        <h3>
          \(signatureText)
        </h3>
        <p>
          \(detailItem.body)
        </p>
      </body>
    </html>
    """
    
    webView.loadHTMLString(html, baseURL: nil)
  }
}
