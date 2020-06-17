//
//  Alert.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 16.06.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import Foundation
import UIKit

class Alert {

  /// Выводит предупреждение в случае ошибки при авторизации
  /// - Parameter viewController: передаем контроллер, в котором необходимо показать предупреждение
  class func showAlert(viewController: UIViewController) {
    DispatchQueue.main.async {
      let alert = UIAlertController(title: "Authentication failed!",
                                    message: "Please, try again.",
                                    preferredStyle: .alert)

      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      viewController.present(alert, animated: true)
    }

  }
}
