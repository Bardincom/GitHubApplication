//
//  SessionProvider.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 30.05.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import Foundation

final class SessionProvider: NSObject {

  private let sharedSession = URLSession.shared
  private let decoder = JSONDecoder()
  private let scheme = "https"
  private let host = "api.github.com"
  private let hostPath = "https://api.github.com"
  private let searchRepoPath = "/search/repositories"

  /// Поиск по GITHub
  /// - Parameters:
  ///   - name: имя репозитория
  ///   - language: язык репозитория
  ///   - order: выбор лучшего совпадения  desc или asc
  func searchRepositiries(name: String?, language: String?, order: String, completionHandler: @escaping ([Repository]) -> Void) {
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

      guard let resquestData = data else { return }

      do {
        let search = try self.decoder.decode(Search.self, from: resquestData)
        guard let repositories = search.repositories else { return }

        DispatchQueue.main.async {
          completionHandler(repositories)
        }

      } catch let error {
        print("Error", error)
      }

    }

    dataTask.resume()
  }
}
