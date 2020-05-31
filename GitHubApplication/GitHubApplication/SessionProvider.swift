//
//  SessionProvider.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 30.05.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import Foundation

class SessionProvider: NSObject {

  public let sharedSession = URLSession.shared
  private let scheme = "https"
  private let host = "api.github.com"
  private let hostPath = "https://api.github.com"
  private let searchRepoPath = "/search/repositories"
  private let defaultHeaders = [
    "Content-Type" : "application/json",
    "Accept" : "application/vnd.github.v3+json"
  ]

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
    var request = URLRequest(url: url)
    request.allHTTPHeaderFields = defaultHeaders

    let dataTask = sharedSession.dataTask(with: url) { (data, response, error) in
      if let error = error {
        print(error.localizedDescription)
        return
      }

      guard let responce = response, let data = data else { return }
      print(responce)

      do {
        let json = try JSONSerialization.jsonObject(with: data)
        print(json)
      } catch {
        print(error)
      }
    }

    dataTask.resume()
  }
}
