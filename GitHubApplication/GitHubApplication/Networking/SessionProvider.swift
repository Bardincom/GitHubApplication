//
//  SessionProvider.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 30.05.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import Foundation

class SessionProvider: NSObject {

  private let sharedSession = URLSession.shared
  private let scheme = "https"
  private let host = "api.github.com"
  private let hostPath = "https://api.github.com"
  private let searchRepoPath = "/search/repositories"

  /// Поиск по GITHub
  /// - Parameters:
  ///   - name: имя репозитория
  ///   - language: язык репозитория
  ///   - order: выбор лучшего совпадения  desc или asc
  func searchRepositiries(name: String?, language: String?, order: String) {
    var urlComponents = URLComponents()
    urlComponents.scheme = scheme
    urlComponents.host = host
    urlComponents.path = searchRepoPath

    guard let name = name, let language = language else { return }

    switch language {
      case "":
        urlComponents.queryItems = [
          URLQueryItem(name: "q", value: "\(name)"),
          URLQueryItem(name: "sort", value: "star"),
          URLQueryItem(name: "order", value: order)
        ]
      default:
        urlComponents.queryItems = [
          URLQueryItem(name: "q", value: "\(name)+language:\(language)"),
          URLQueryItem(name: "sort", value: "stars"),
          URLQueryItem(name: "order", value: order)
        ]
    }

    guard let url = urlComponents.url else { return }
    print(url)

    let dataTask = sharedSession.dataTask(with: url) { (data, response, error) in
      if let error = error {
        print(error.localizedDescription)
        return
      }

      guard let data = data else { return }

      do {
        let json = try JSONSerialization.jsonObject(with: data)
        print("Тут начинается JSON: \(json)")
      } catch {
        print(error)
      }
    }

    dataTask.resume()
  }
}
