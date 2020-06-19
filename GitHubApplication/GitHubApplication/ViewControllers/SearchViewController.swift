//
//  SearchViewController.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 29.05.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {

  @IBOutlet private var helloUser: UILabel!
  @IBOutlet private var avatarImage: UIImageView!
  @IBOutlet private var searchRepositoryName: UITextField!
  @IBOutlet private var searchLanguage: UITextField!
  @IBOutlet private var filterControl: UISegmentedControl!
  @IBOutlet private var startSearchButton: UIButton!

  public var userName: String?
  public var userAvatarURL: URL?
  private let sessionProvider = SessionProvider()
  private let repositoryNamePlaceholder = "repository name"
  private let languagePlaceholder = "language"
  private let defaultRequestText = ""
  private var filter = Order.descendedOrder

  override func viewDidLoad() {
    super.viewDidLoad()
    disableSearchButton()
    setDelegate()
    customizeItems()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    disableSearchButton()
    notificationAddObserver(#selector(keyboardWillShown(notification:)))
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    notificationRemoveObserver()
  }

  @IBAction func pressStartSearch(_ sender: UIButton) {
    let searchRepositoryViewController = SearchResultsViewController()
    searchRepositoryViewController.searchRepository.name = searchRepositoryName.text ?? defaultRequestText
    searchRepositoryViewController.searchRepository.language = searchLanguage.text ?? defaultRequestText
    searchRepositoryViewController.searchRepository.order = filter

    navigationController?.pushViewController(searchRepositoryViewController, animated: true)
  }

  @IBAction func filterControl(_ sender: UISegmentedControl) {
    switch filterControl.selectedSegmentIndex {
      case 0:
        filter = Order.ascendedOrder
      default:
        filter = Order.descendedOrder
    }
  }

  @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
    searchRepositoryName.resignFirstResponder()
    searchLanguage.resignFirstResponder()
  }
}

// MARK: SearchViewController + Helper
private extension SearchViewController {

  func customizeItems() {
    searchRepositoryName.placeholder = repositoryNamePlaceholder
    searchLanguage.placeholder = languagePlaceholder
    startSearchButton.layer.cornerRadius = cornerRadiusButton

    avatarImage.layer.cornerRadius = avatarImage.bounds.height / 2
    avatarImage.backgroundColor = .white
    avatarImage.kf.setImage(with: userAvatarURL)

    guard let userName = userName else { return }
    helloUser.text = "Hello, \(userName)"
  }

  func setDelegate() {
    searchRepositoryName.delegate = self
    searchLanguage.delegate = self
  }

  func disableSearchButton() {
    startSearchButton.isEnabled = false
    startSearchButton.alpha = 0.5
  }

  func enableSearchButton() {
    startSearchButton.isEnabled = true
    startSearchButton.alpha = 1
  }
}

// MARK: Selectors
private extension SearchViewController {

  @objc
  func keyboardWillShown(notification: NSNotification) {

    guard let size = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

    guard view.bounds.height > maxHeightFrame else {
      shiftView(size, searchRepositoryName, searchLanguage, Factor.compact)
      return
    }

    shiftView(size, searchRepositoryName, searchLanguage, Factor.regular)
  }
}

// MARK: TextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let simbolCount = searchRepositoryName.text?.count else { return }

    if simbolCount > 0 {
      enableSearchButton()
    } else {
      disableSearchButton()
    }

  }
}
