//
//  User.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 08.06.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import Foundation

public struct User: Codable {
  var login: String?
  var avatarURL: URL?

  private enum CodingKeys: String, CodingKey {
    case login
    case avatarURL = "avatar_url"
  }
}
