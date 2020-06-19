//
//  LoginViewController.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 19.05.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit
import Kingfisher

final class LoginViewController: UIViewController {

  @IBOutlet var logoImageView: UIImageView!
  @IBOutlet var usernameTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!
  @IBOutlet var loginButton: UIButton!

  /// загружаемое из интернета изобржение
  private let urlImage = URL(string: "https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png")

  private let usernamePlaceholder = "username"
  private let passwordPlaceholder = "password"
  private let identifier = "loginViewController"
  private let service = "GitHub"
  private let sessionProvider = SessionProvider()

  override func viewDidLoad() {
    super.viewDidLoad()

    setDelegate()
    customizeItems()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    notificationAddObserver(#selector(keyboardWillShown(notification:)))
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    notificationRemoveObserver()
  }

  @IBAction func pressLoginButton(_ sender: Any) {
    guard let userViewController = storyboard?.instantiateViewController(identifier: identifier) as? SearchViewController else { return }
    guard let userName = usernameTextField?.text,
      let userPassword = passwordTextField?.text else { return }

    sessionProvider.authorizationUser(name: userName, password: userPassword) { [weak self] result in
      guard let self = self else { return }
      switch result {
        case .success(let user):
          let saveResult = self.savePassword(password: userPassword, account: userName)
          print(saveResult)
          if saveResult, let savedPassword = self.readPassword(account: userName) {
            print("password:\(savedPassword) saved successfully with service name:\(self.service) and account:\(userName)")
          }

          userViewController.userName = user.login
          userViewController.userAvatarURL = user.avatarURL
          self.navigationController?.pushViewController(userViewController, animated: true)

        case .fail( _):
          Alert.showAlert(viewController: self)
      }
    }
  }

  @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
    usernameTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
  }
}

// MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

// MARK: Helpers Methods
private extension LoginViewController {

  /// настройка внешнего вида UI элементов
  func customizeItems() {
    usernameTextField.placeholder = usernamePlaceholder
    passwordTextField.placeholder = passwordPlaceholder
    passwordTextField.isSecureTextEntry = true
    loginButton.layer.cornerRadius = cornerRadiusButton

    logoImageView.kf.setImage(with: urlImage)
  }

  func setDelegate() {
    usernameTextField.delegate = self
    passwordTextField.delegate = self
  }

  func keychainQuery(account: String? = nil) -> [String: AnyObject] {
    var query = [String: AnyObject]()
    query[kSecClass as String] = kSecClassGenericPassword
    query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
    query[kSecAttrService as String] = service as AnyObject

    guard let account = account else { return query }

    query[kSecAttrAccount as String] = account as AnyObject

    return query
  }

  func readPassword(account: String?) -> String? {
    var query = keychainQuery(account: account)
    query[kSecMatchLimit as String] = kSecMatchLimitOne
    query[kSecReturnData as String] = kCFBooleanTrue
    query[kSecReturnAttributes as String] = kCFBooleanTrue

    var queryResult: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(&queryResult))

    if status != noErr {
      return nil
    }

    guard let item = queryResult as? [String: AnyObject],
      let passwordData = item[kSecValueData as String] as? Data,
      let password = String(data: passwordData, encoding: .utf8) else { return nil }

    return password
  }

  func savePassword(password: String, account: String?) -> Bool {
    let passwordData = password.data(using: .utf8)

    guard readPassword(account: account) == nil else {
      var attributesToUpdate = [String: AnyObject]()
      attributesToUpdate[kSecValueData as String] = passwordData as AnyObject
      let query = keychainQuery(account: account)
      let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
      return status == noErr
    }

    var item = keychainQuery(account: account)
    item[kSecValueData as String] = passwordData as AnyObject
    let status = SecItemAdd(item as CFDictionary, nil)
    return status == noErr

  }
}

// MARK: Selectors
private extension LoginViewController {

  @objc
  func keyboardWillShown(notification: NSNotification) {

    guard let size = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

    guard view.bounds.height > maxHeightFrame else {
      shiftView(size, usernameTextField, passwordTextField, Factor.compact)
      return
    }

    shiftView(size, usernameTextField, passwordTextField, Factor.regular)
  }
}
