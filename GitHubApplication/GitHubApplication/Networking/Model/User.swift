//
//  User.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 08.06.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import Foundation

public struct User: Codable {
  var userLogin: String?
  var avatarURL: URL?

  private enum CodingKeys: String, CodingKey {
    // Аналогично. Юзер логин некорректно называть. Либо юзернэйм, либо логин. В твоем случае логин поудачнее будет
    case userLogin = "login"
    case avatarURL = "avatar_url"
  }
}
