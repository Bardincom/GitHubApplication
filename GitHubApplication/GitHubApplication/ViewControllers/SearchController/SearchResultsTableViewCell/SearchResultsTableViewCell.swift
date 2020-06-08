//
//  SearchResultsTableViewCell.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 08.06.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {

  @IBOutlet var repositoryName: UILabel!
  @IBOutlet var descriptionRepository: UILabel!
  @IBOutlet var userName: UILabel!
  @IBOutlet var avatarImage: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()

    avatarImage.layer.cornerRadius = avatarImage.bounds.height / 2
    avatarImage.backgroundColor = .yellow
  }

  func setupRepositoryList(repository: Repository) {
      repositoryName.text = repository.nameRepository
      descriptionRepository.text = repository.descriptionRepository
      userName.text = repository.userRepository?.userLogin
  }

}
