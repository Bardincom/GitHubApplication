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

  override func viewDidLoad() {
    super.viewDidLoad()

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
    print("Press Login Button")
  }

  @IBAction func returnUsername(_ sender: UITextField) {
    sender.resignFirstResponder()
  }
  @IBAction func returnPassword(_ sender: UITextField) {
    sender.resignFirstResponder()
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
    usernameTextField.placeholder = "username"
    passwordTextField.placeholder = "password"
    loginButton.layer.cornerRadius = 5
  }

  /// смещает клавиатуру в зависимости от размера экрана
  func shiftView (_ keyboardSize: CGRect,
                  _ firstTextField: UITextField,
                  _ secondTextField: UITextField,
                  _ factor: CGFloat) {
    if firstTextField.isEditing {
      self.view.frame.origin.y = -keyboardSize.height * factor
    } else if secondTextField.isEditing {
      self.view.frame.origin.y = -keyboardSize.height * factor
    }
  }

  /// сообщает что клавиатура появилась
  func notificationAddObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  /// сообщает что клавиатура была скрыта
  func notificationRemoveObserver() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
}

// MARK: Selectors
private extension LoginViewController {

  @objc
  func keyboardWillHide() {
    self.view.frame.origin.y = 0
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
