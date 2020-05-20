//
//  LoginViewController.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 19.05.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
// https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png

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

  @IBAction func pressLoginButton(_ sender: Any) {
    print("Press Login Button")
  }

}

private extension LoginViewController {
  func setLogo() {
    let urlLogoImage = urlImage
    self.logoImageView.kf.setImage(with: urlLogoImage)
  }

  func customizeItems() {
    usernameTextField.placeholder = "username"
    passwordTextField.placeholder = "password"
    loginButton.layer.cornerRadius = 5
  }
}
