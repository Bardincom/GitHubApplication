//
//  Constants.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 20.05.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.

import Foundation
import UIKit

public let maxHeightFrame: CGFloat = 736
public let cornerRadiusButton: CGFloat = 5
public let defaultAvatar: UIImage = #imageLiteral(resourceName: "defaultAvatar")
public let heightForHeaderTableView: CGFloat = 40

/// Коэффициент изменяющий смещение view относительно клавиатуры, для экранов с большим и маленьким рарзешением
enum Factor {
  static let compact: CGFloat = 0.8
  static let regular: CGFloat = 0.3
}

/// Порядок формирования результата
enum Order {
  static let ascendedOrder = "asc"
  static let descendedOrder = "desc"
}
