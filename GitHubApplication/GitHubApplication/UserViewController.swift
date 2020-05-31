//
//  UserViewController.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 29.05.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

final class UserViewController: UIViewController {

  @IBOutlet private var helloUser: UILabel!
  @IBOutlet private var avatarImage: UIImageView!
  @IBOutlet private var searchRepositoryName: UITextField!
  @IBOutlet private var searchLanguage: UITextField!
  @IBOutlet private var startSearchButton: UIButton!

  let sessionProvider = SessionProvider()
  public var userName: String?
  private let repositoryNamePlaceholder = "repository name"
  private let languagePlaceholder = "language"

  override func viewDidLoad() {
    super.viewDidLoad()
    customizeItems()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

  }

  @IBAction func pressStartSearch(_ sender: UIButton) {

    sessionProvider.searchRepositiries(name: searchRepositoryName.text ?? "",
                                       language: searchLanguage.text ?? "",
                                       filter: "asc")
  }


  @IBAction func filterControl(_ sender: UISegmentedControl) {
    
  }
}

private extension UserViewController {

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
}
