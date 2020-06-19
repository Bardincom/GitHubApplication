//
//  UIViewController + Extension.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 31.05.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

extension UIViewController {

  /// Cмещает клавиатуру в зависимости от размера экрана
  /// - Parameters:
  ///   - keyboardSize: размер клавиатуры
  ///   - firstTextField: первое текстовое
  ///   - secondTextField: второе текстовое
  ///   - factor: множитель в зависимости от размера экрана
  func shiftView (_ keyboardSize: CGRect,
                  _ firstTextField: UITextField,
                  _ secondTextField: UITextField,
                  _ factor: CGFloat) {
    if firstTextField.isFirstResponder {
      self.view.frame.origin.y = -keyboardSize.height * factor
    } else if secondTextField.isFirstResponder {
      self.view.frame.origin.y = -keyboardSize.height * factor
    }
  }
}

// MARK: ViewController Notification
extension UIViewController {

  /// сообщает что клавиатура появилась
  /// - Parameter keyboardWillShownSelector: необходимо передать метод в селектор, отвечающий за появление клавиатуры
  func notificationAddObserver(_ keyboardWillShownSelector: Selector) {
    NotificationCenter.default.addObserver(self,
                                           selector: keyboardWillShownSelector,
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

  /// метод вызывается когда клавиатура скрывается
  @objc
  func keyboardWillHide() {
    self.view.frame.origin.y = .zero
  }
}
