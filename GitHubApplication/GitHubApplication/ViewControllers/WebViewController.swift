//
//  WebViewController.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 13.06.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//  swiftlint:disable implicitly_unwrapped_optional

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController {

  private let backgroundColor = "red"
  private let sourseString = "document.body.style.background"
  private let titleWebView = "Loading..."

  public lazy var webView: WKWebView = {
    let view = WKWebView()
    view.navigationDelegate = self
    return view
  }()

  var htmlUrl: String?
  var userName: String?

  override func loadView() {
    setupWebViewController()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    displayUserRepository()
  }

}

// MARK: WebViewController + Helper
private extension WebViewController {
  func setupWebViewController() {
    let webConfiguration = WKWebViewConfiguration()
    webConfiguration.userContentController = setupJsStyleBackground()

    webView = WKWebView(frame: .zero, configuration: webConfiguration)
    webView.navigationDelegate = self
    title = titleWebView
    view = webView
  }

  func displayUserRepository() {
    guard let htmlUrl = htmlUrl,
      let repositoryURL = URL(string: htmlUrl) else { return }

    let request = URLRequest(url: repositoryURL)

    webView.load(request)
    webView.allowsBackForwardNavigationGestures = true
  }

  func setupJsStyleBackground() -> WKUserContentController {
    let sourse = setupSourse(sourseString, backgroundColor)
    let userScript = WKUserScript(source: sourse, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

    let userContentController = WKUserContentController()
    userContentController.addUserScript(userScript)

    return userContentController
  }

  func setupSourse(_ string: String, _ color: String) -> String {
    return "\(string) = \"\(color)\""
  }
}

// MARK: WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    guard let userName = userName else { return }
    title = "\(userName)"
  }
}
