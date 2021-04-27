//
//  DetailViewController.swift
//  Project 16
//
//  Created by Samuel Shi on 4/27/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
  var webView: WKWebView!
  var progressView: UIProgressView!
  var website: URL!
  
  override func loadView() {
    webView = WKWebView()
    webView.navigationDelegate = self
    view = webView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    
    guard website != nil else {
      print("Website not set")
      navigationController?.popViewController(animated: true)
      return
    }
    
    makeToolbar()
    openWebpage()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    navigationController?.isToolbarHidden = true

  }
  
  func openWebpage() {
    webView.load(URLRequest(url: website))
    webView.allowsBackForwardNavigationGestures = true
  }
  
  func makeToolbar() {
    let back = UIBarButtonItem(
      image: UIImage(systemName: "chevron.left"),
      style: .plain,
      target: webView,
      action: #selector(webView.goBack))
    
    let padding = UIBarButtonItem(systemItem: .fixedSpace)
    padding.width = 15
    
    let forward = UIBarButtonItem(
      image: UIImage(systemName: "chevron.right"),
      style: .plain,
      target: webView,
      action: #selector(webView.goForward))
    
    let spacer = UIBarButtonItem(
      barButtonSystemItem: .flexibleSpace,
      target: nil,
      action: nil)
    
    let refresh = UIBarButtonItem(
      barButtonSystemItem: .refresh,
      target: webView,
      action: #selector(webView.reload))
    
    progressView = UIProgressView(progressViewStyle: .default)
    progressView.sizeToFit()
    let progressButton = UIBarButtonItem(customView: progressView)
    
    webView.addObserver(self,
      forKeyPath: #keyPath(WKWebView.estimatedProgress),
      options: .new,
      context: nil)
    
    toolbarItems = [
      progressButton, spacer,
      back, padding, refresh,
      padding, forward
    ]
    navigationController?.isToolbarHidden = false
  }
  
  override func observeValue(
    forKeyPath keyPath: String?,
    of object: Any?,
    change: [NSKeyValueChangeKey : Any]?,
    context: UnsafeMutableRawPointer?
  ) {
    if keyPath == "estimatedProgress" {
      progressView.progress = Float(webView.estimatedProgress)
      if progressView.progress == 1 {
        progressView.isHidden = true
      } else if progressView.isHidden {
        progressView.isHidden = false
      }
    }
  }
}

extension WebViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    title = webView.title
  }
}
