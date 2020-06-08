//
//  SearchResultsViewController.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 08.06.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {

  var repositories: [Repository] = []

  @IBOutlet weak var searcTableView: UITableView! {
    willSet {
      newValue.register(nibCell: SearchResultsTableViewCell.self)
    }
  }

  override func viewDidLoad() {
        super.viewDidLoad()

    }

}

// MARK: TableViewDelegate
extension SearchResultsViewController: UITableViewDelegate {

//  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    let view = UIView()
//    view.backgroundColor = .yellow
//    let label = UILabel()
//    label.text = "Repositories found: \(repositories.count)"
//    return label
//  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    "Repositories found: \(repositories.count)"
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    heightForHeaderTableView
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
