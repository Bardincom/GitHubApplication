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
