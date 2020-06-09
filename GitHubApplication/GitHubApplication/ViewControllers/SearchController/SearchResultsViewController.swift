//
//  SearchResultsViewController.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 08.06.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

final class SearchResultsViewController: UIViewController {

  public var searchRepository: (name: String?, language: String?, order: String?)
  private var repositories: [Repository] = []
  private let sessionProvider = SessionProvider()

  @IBOutlet weak var searcTableView: UITableView! {
    willSet {
      newValue.register(nibCell: SearchResultsTableViewCell.self)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    downloadSearchData()
  }

}

// MARK: TableViewDelegate
extension SearchResultsViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = UILabel()
    label.text = "  Repositories found: \(repositories.count)"
    label.backgroundColor = .white
    return label
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    heightForHeaderTableView
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: TableViewDataSource
extension SearchResultsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    repositories.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue(reusable: SearchResultsTableViewCell.self, for: indexPath)

    cell.setupRepositoryList(repository: repositories[indexPath.row])

    return cell
  }
}

private extension SearchResultsViewController {
  func downloadSearchData() {
    sessionProvider.searchRepositiries(name: searchRepository.name,
                                       language: searchRepository.language,
                                       order: searchRepository.order ?? Filter.descendedFilter) { foundRepository in
                                        self.repositories = foundRepository
                                        self.searcTableView.reloadData()
    }
  }
}
