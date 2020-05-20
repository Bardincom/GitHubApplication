//
//  Constants.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 20.05.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//   https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png

import Foundation
import UIKit

/// загружаемое из интернета изобржение
public let urlImage = URL(string: "https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png")

public let maxHeightFrame: CGFloat = 736

/// коэффициент изменяющий смещение view относительно клавиатуры, для экранов с большим и маленьким рарзешением
enum Factor {
  static let compact: CGFloat = 0.8
  static let regular: CGFloat = 0.3
}
