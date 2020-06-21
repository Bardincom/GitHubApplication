//
//  LoginViewController.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 19.05.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit
import Kingfisher
import LocalAuthentication

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
  private var isSavePassword = false

  override func viewDidLoad() {
    super.viewDidLoad()
    setDelegate()
    customizeItems()
//    deletePassword()

    authenticateUser()

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
          self.isSavePassword = self.savePassword(password: userPassword, account: userName)

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
}

// MARK: Keychain

private extension LoginViewController {
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

  private func readAllItems() -> [String : String]? {
    var query = keychainQuery()
    query[kSecMatchLimit as String] = kSecMatchLimitAll
    query[kSecReturnData as String] = kCFBooleanTrue
    query[kSecReturnAttributes as String] = kCFBooleanTrue

    var queryResult: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(&queryResult))

    if status != noErr {
      return nil
    }

    guard let items = queryResult as? [[String : AnyObject]] else {
      return nil
    }
    var passwordItems = [String : String]()

    for (index, item) in items.enumerated() {
      guard let passwordData = item[kSecValueData as String] as? Data,
        let password = String(data: passwordData, encoding: .utf8) else {
          continue
      }

      if let account = item[kSecAttrAccount as String] as? String {
        passwordItems[account] = password
        continue
      }

      let account = "empty account \(index)"
      passwordItems[account] = password
    }
    return passwordItems
  }

  private func deletePassword() -> Bool {
         let item = keychainQuery()
         let status = SecItemDelete(item as CFDictionary)
         return status == noErr
     }
}

// MARK: AuthenticationWithBiometrics
private extension LoginViewController {
  func authenticateUser() {
    guard let result = readAllItems() else { return }
    guard let userViewController = storyboard?.instantiateViewController(identifier: identifier) as? SearchViewController else { return }
    let authenticationContext = LAContext()
    setupAuthenticationContext(context: authenticationContext)

    let reason = "Fast and safe authentication in your app"
    var authError: NSError?

    if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
      authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [unowned self] success, evaluateError in
        if success {
          // Пользователь успешно прошел аутентификацию
          for (account, password) in result {
            self.sessionProvider.authorizationUser(name: account, password: password) { [weak self] result in
              guard let self = self else { return }
              switch result {
                case .success(let user):
                  userViewController.userName = user.login
                  userViewController.userAvatarURL = user.avatarURL
                  self.navigationController?.pushViewController(userViewController, animated: true)

                case .fail( _):
                  Alert.showAlert(viewController: self)
              }
            }
          }
        } else {
          // Пользователь не прошел аутентификацию
          if let error = evaluateError {
            print(error.localizedDescription)
          }
        }
      }
    } else {
      // Не удалось выполнить проверку на использование биометрических данных или пароля для аутентификации

      if let error = authError {
        print(error.localizedDescription)
      }
    }
  }

  func setupAuthenticationContext(context: LAContext) {
    context.localizedReason = "Use for fast and safe authentication in your app"
    context.localizedCancelTitle = "Cancel"
    context.localizedFallbackTitle = "Enter password"

    context.touchIDAuthenticationAllowableReuseDuration = 600
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
