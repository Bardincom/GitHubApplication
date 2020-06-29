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
  private let sessionProvider = SessionProvider()
  private var isSavePassword = false
  private var keychaine = Keychain.shared

  override func viewDidLoad() {
    super.viewDidLoad()
    setDelegate()
    customizeItems()
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
          self.isSavePassword = self.keychaine.savePassword(password: userPassword, account: userName)

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

// MARK: AuthenticationWithBiometrics
private extension LoginViewController {
  func authenticateUser() {
    guard let keys = keychaine.readAllItems() else { return }
    
    let authenticationContext = LAContext()
    setupAuthenticationContext(context: authenticationContext)

    let reason = "Fast and safe authentication in your app"
    var authError: NSError?

    guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) else {
      // Не удалось выполнить проверку на использование биометрических данных или пароля для аутентификации
      if let error = authError {
        print(error.localizedDescription)
      }
      return
    }

    authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [unowned self] success, evaluateError in

      guard success else {
        // Пользователь не прошел аутентификацию
        if let error = evaluateError {
          print(error.localizedDescription)
        }
        return
      }
      self.successfulAuthentication(keys)
    }
  }

  func setupAuthenticationContext(context: LAContext) {
    context.localizedReason = "Use for fast and safe authentication in your app"
    context.localizedCancelTitle = "Cancel"
    context.localizedFallbackTitle = "Enter password"
    context.touchIDAuthenticationAllowableReuseDuration = 300
  }

  /// Пользователь успешно прошел аутентификацию
  func successfulAuthentication(_ keys: [String : String]) {
    DispatchQueue.main.async {
      guard let userViewController = self.storyboard?.instantiateViewController(identifier: self.identifier) as? SearchViewController else { return }
      for (account, password) in keys {
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
    }
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
