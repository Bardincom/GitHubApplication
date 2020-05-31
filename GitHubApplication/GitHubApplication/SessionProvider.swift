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

  func searchRepositoriesRequest() /*-> URLRequest?*/ {
    // 9
    var urlComponents = URLComponents()
    // 10 схему обращения к ресурсу
    urlComponents.scheme = scheme
    // 11 адрес сервера
    urlComponents.host = host
    // 12 указываем конкретный путь к ресурсу на сервере
    urlComponents.path = searchRepoPath
    // 13 необходимые параметры запроса
    urlComponents.queryItems = [
      URLQueryItem(name: "q", value: "tetris+language:swift+stars:>3"),
      URLQueryItem(name: "sort", value: "stars"),
      URLQueryItem(name: "order", value: "desc")
    ]

    guard let url = urlComponents.url else {
      return /*nil*/
    }
    print("search request url:\(url)")
    var request = URLRequest(url: url)
    request.allHTTPHeaderFields = defaultHeaders
    print(request)
    //    return request
  }

  func searchRepositiries(name: String?, language: String?, filter: String) {
    var urlComponents = URLComponents()
    urlComponents.scheme = scheme
    urlComponents.host = host
    urlComponents.path = searchRepoPath
    guard let name = name, let language = language else { return }

    switch language {
      case "":
        urlComponents.queryItems = [
          URLQueryItem(name: "q", value: "\(name)"),
          URLQueryItem(name: "order", value: filter)
        ]
      default:
        urlComponents.queryItems = [
          URLQueryItem(name: "q", value: "\(name)+language:\(language)"),
          URLQueryItem(name: "order", value: filter)
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
      print(data)

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
