//
//  SessionProvider.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 30.05.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import Foundation
import UIKit

enum Result<T> {
  case success(T)
  case fail(Error)
}

enum BackendError: Error {
    case urlError(reason: String)
    case objectSerialization(reason: String)
}

final class SessionProvider {

  private let sharedSession = URLSession.shared
  private let decoder = JSONDecoder()
  private let scheme = "https"
  private let host = "api.github.com"
  private let hostPath = "https://api.github.com"

  enum Path {
    static let searchRepoPath = "/search/repositories"
    static let userPath = "/user"
  }

  func authorizationUser(name: String,
                         password: String,
                         completionHandler: @escaping (Result<User>) -> Void) {

    ActivityIndicator.start()
    guard let userData = "\(name):\(password)".data(using: .utf8)?.base64EncodedString() else { return }

    let urlComponents = preparationURLComponents(path: Path.userPath)

    guard let url = urlComponents.url else { return }

    var request = URLRequest(url: url)
    request.addValue("Basic \(userData)", forHTTPHeaderField: "Authorization")

    let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in

      if let httpResponse = response as? HTTPURLResponse {
        if httpResponse.statusCode == 401 {

          let error = BackendError.objectSerialization(reason: "http response error: status code \(httpResponse.statusCode), description: Unauthorized")
          ActivityIndicator.stop()
          completionHandler(.fail(error))
          return
        }
        print("http status code: \(httpResponse.statusCode)")
      }

      guard let resquestData = data else { return }

      do {
        let user = try self.decoder.decode(User.self, from: resquestData)
        DispatchQueue.main.async {
          completionHandler(.success(user))
          ActivityIndicator.stop()
        }

      } catch let error {
        completionHandler(.fail(error))
      }

    }

    dataTask.resume()

  }

  func getRepositiries(name: String?,
                       language: String?,
                       order: String,
                       completionHandler: @escaping ([Repository]) -> Void) {

    guard let url = preparationRepositoryURL(name: name, language: language, order: order) else { return }

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

private extension SessionProvider {
  func preparationURLComponents(path: String) -> URLComponents {
    var urlComponents = URLComponents()
    urlComponents.scheme = scheme
    urlComponents.host = host
    urlComponents.path = path

    return urlComponents
  }

  /// Подготовка URL строки для дальнейшего поиска
  /// - Parameters:
  ///   - name: имя репозитория
  ///   - language: язык репозитория
  ///   - order: выбор лучшего совпадения  desc или asc
  private func preparationRepositoryURL(name: String?,
                                        language: String?,
                                        order: String) -> URL? {

    var urlComponents = preparationURLComponents(path: Path.searchRepoPath)

    guard let name = name, let language = language else { return nil }

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

    return urlComponents.url
  }
}
