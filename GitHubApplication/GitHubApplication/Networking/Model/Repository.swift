//
//  Repository.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 08.06.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import Foundation

public struct Repository: Codable {
  var nameRepository: String?
  var userRepository: User?
  var descriptionRepository: String?
  var urlUserRepository: String?

  private enum CodingKeys: String, CodingKey {
    // Можно сразу имена сделать такими, как ты написал здесь. Кроме урла. А все остальное и так понятно, что относится к репозиторию
    case nameRepository = "name"
    case descriptionRepository = "description"
    case userRepository = "owner"
    case urlUserRepository = "html_url"
  }
}
