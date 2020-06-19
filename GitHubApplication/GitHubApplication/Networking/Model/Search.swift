//
//  Search.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 08.06.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import Foundation

public struct Search: Codable {
  var repositories: [Repository]?

  private enum CodingKeys: String, CodingKey {
    // почему ты сразу не назвал items? Не надо было бы тогда лепить этот кодин кейс
    case repositories = "items"
  }
}
