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
  private let sessionProvider = SessionProvider()
  private let repositoryNamePlaceholder = "repository name"
  private let languagePlaceholder = "language"
  private let defaultRequestText = ""
  private var filter = Filter.descendedFilter

  override func viewDidLoad() {
    super.viewDidLoad()

    setDelegate()
    customizeItems()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    clearText()
    notificationAddObserver(#selector(keyboardWillShown(notification:)))
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    notificationRemoveObserver()
  }

  @IBAction func pressStartSearch(_ sender: UIButton) {
    let searchRepositoryViewController = SearchResultsViewController()
    sessionProvider.searchRepositiries(name: searchRepositoryName.text ?? defaultRequestText,
                                           language: searchLanguage.text ?? defaultRequestText,
                                           order: filter) { repositories in
                                            searchRepositoryViewController.repositories = repositories
                                             self.navigationController?.pushViewController(searchRepositoryViewController, animated: true)
    }
  }

  @IBAction func filterControl(_ sender: UISegmentedControl) {
    switch filterControl.selectedSegmentIndex {
      case 0:
        filter = Filter.ascendedFilter
      default:
        filter = Filter.descendedFilter
    }
  }

  @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
    searchRepositoryName.resignFirstResponder()
    searchLanguage.resignFirstResponder()
  }
}

private extension SearchViewController {

  func customizeItems() {
    searchRepositoryName.placeholder = repositoryNamePlaceholder
    searchLanguage.placeholder = languagePlaceholder
    startSearchButton.layer.cornerRadius = cornerRadiusButton
    avatarImage.image = defaultAvatar
    avatarImage.layer.borderColor = UIColor.red.cgColor
    avatarImage.layer.cornerRadius = avatarImage.bounds.height / 2

    guard let userName = userName else { return }
    helloUser.text = "Hello, \(userName)"
  }

  func setDelegate() {
    searchRepositoryName.delegate = self
    searchLanguage.delegate = self
  }

  func clearText() {
    searchRepositoryName.text = nil
    searchLanguage.text = nil
  }

}

// MARK: Selectors
private extension SearchViewController {

  @objc
  func keyboardWillShown(notification: NSNotification) {

    if let size = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

      guard view.bounds.height > maxHeightFrame else {
        shiftView(size, searchRepositoryName, searchLanguage, Factor.compact)
        return
      }

      shiftView(size, searchRepositoryName, searchLanguage, Factor.regular)

    }
  }
}

// MARK: TextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
