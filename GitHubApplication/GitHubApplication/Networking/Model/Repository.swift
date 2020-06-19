//
//  Repository.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 08.06.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import Foundation

public struct Repository: Codable {
  var name: String?
  var user: User?
  var description: String?
  var urlUserRepository: String?

  private enum CodingKeys: String, CodingKey {
    case name, description
    case user = "owner"
    case urlUserRepository = "html_url"
  }
}
