//
//  Keychain.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 22.06.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import Foundation

final class Keychain {

  private let service = "GitHub"
  static let shared: Keychain = {
    let keychain = Keychain()
    return keychain
  }()

  private init() { }

  func savePassword(password: String, account: String?) -> Bool {
    let passwordData = password.data(using: .utf8)

    guard readPassword(account: account) == nil else {
      var attributesToUpdate = [String: AnyObject]()
      attributesToUpdate[kSecValueData as String] = passwordData as AnyObject
      let query = keychainQuery(account: account)
      let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
      return status == noErr
    }

    var item = keychainQuery(account: account)
    item[kSecValueData as String] = passwordData as AnyObject
    let status = SecItemAdd(item as CFDictionary, nil)
    return status == noErr
  }

  func readAllItems() -> [String : String]? {
    var query = keychainQuery()
    query[kSecMatchLimit as String] = kSecMatchLimitAll
    query[kSecReturnData as String] = kCFBooleanTrue
    query[kSecReturnAttributes as String] = kCFBooleanTrue

    let queryDictionary = query as CFDictionary
    var queryResult: CFTypeRef?
    let status = SecItemCopyMatching(queryDictionary, &queryResult)

    if status != noErr {
      return nil
    }

    guard let items = queryResult as? [[String : AnyObject]] else {
      return nil
    }
    var passwordItems = [String : String]()

    for (index, item) in items.enumerated() {
      guard let passwordData = item[kSecValueData as String] as? Data,
        let password = String(data: passwordData, encoding: .utf8) else {
          continue
      }

      if let account = item[kSecAttrAccount as String] as? String {
        passwordItems[account] = password
        continue
      }

      let account = "empty account \(index)"
      passwordItems[account] = password
    }
    return passwordItems
  }

}

private extension Keychain {

  func keychainQuery(account: String? = nil) -> [String: AnyObject] {
    var query = [String: AnyObject]()
    query[kSecClass as String] = kSecClassGenericPassword
    query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
    query[kSecAttrService as String] = service as AnyObject

    guard let account = account else { return query }

    query[kSecAttrAccount as String] = account as AnyObject
    return query
  }

  func readPassword(account: String?) -> String? {
    var query = keychainQuery(account: account)
    query[kSecMatchLimit as String] = kSecMatchLimitOne
    query[kSecReturnData as String] = kCFBooleanTrue
    query[kSecReturnAttributes as String] = kCFBooleanTrue

    let queryDictionary = query as CFDictionary
    var queryResult: CFTypeRef?
    let status = SecItemCopyMatching(queryDictionary, &queryResult)

    if status != noErr {
      return nil
    }

    guard let item = queryResult as? [String: AnyObject],
      let passwordData = item[kSecValueData as String] as? Data,
      let password = String(data: passwordData, encoding: .utf8) else { return nil }
    return password
  }

  func deletePassword() -> Bool {
    let query = keychainQuery()
    let status = SecItemDelete(query as CFDictionary)
    return status == noErr
  }
}
