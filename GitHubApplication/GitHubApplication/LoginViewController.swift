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
  private let identifier = "userViewController"

  override func viewDidLoad() {
    super.viewDidLoad()

    setDelegate()
    setLogo()
    customizeItems()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    notificationAddObserver()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    notificationRemoveObserver()
  }

  @IBAction func pressLoginButton(_ sender: Any) {
    guard let userViewController = storyboard?.instantiateViewController(identifier: identifier) as? UserViewController else { return }

    let userName = usernameTextField.text
    userViewController.userName = userName
    navigationController?.pushViewController(userViewController, animated: true)
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

  /// установка загруженного изображения
  func setLogo() {
    let urlLogoImage = urlImage
    self.logoImageView.kf.setImage(with: urlLogoImage)
  }

  /// настройка внешнего вида UI элементов
  func customizeItems() {
    usernameTextField.placeholder = usernamePlaceholder
    passwordTextField.placeholder = passwordPlaceholder
    passwordTextField.isSecureTextEntry = true
    loginButton.layer.cornerRadius = cornerRadiusButton
  }

  func setDelegate() {
    usernameTextField.delegate = self
    passwordTextField.delegate = self
  }

  /// сообщает что клавиатура появилась
  func notificationAddObserver() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillChange(notification:)),
                                           name: UIResponder.keyboardWillChangeFrameNotification,
                                           object: nil)

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }

  /// сообщает что клавиатура была скрыта
  func notificationRemoveObserver() {
    NotificationCenter.default.removeObserver(self,
                                              name: UIResponder.keyboardWillChangeFrameNotification,
                                              object: nil)
    NotificationCenter.default.removeObserver(self,
                                              name: UIResponder.keyboardWillHideNotification,
                                              object: nil)
  }
}

// MARK: Selectors
private extension LoginViewController {

  @objc
  func keyboardWillHide() {
    self.view.frame.origin.y = .zero
  }

  @objc
  func keyboardWillChange(notification: NSNotification) {

    if let size = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

      guard view.bounds.height > maxHeightFrame else {
        shiftView(size, usernameTextField, passwordTextField, Factor.compact)
        return
      }

      shiftView(size, usernameTextField, passwordTextField, Factor.regular)

    }
  }
}
