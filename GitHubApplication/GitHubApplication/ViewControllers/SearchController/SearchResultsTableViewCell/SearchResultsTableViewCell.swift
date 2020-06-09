//
//  SearchResultsTableViewCell.swift
//  GitHubApplication
//
//  Created by Aleksey Bardin on 08.06.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import UIKit

final class SearchResultsTableViewCell: UITableViewCell {

  @IBOutlet private var repositoryName: UILabel!
  @IBOutlet private var descriptionRepository: UILabel!
  @IBOutlet private var userName: UILabel!
  @IBOutlet private var avatarImage: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()

    avatarImage.layer.cornerRadius = avatarImage.bounds.height / 2
  }

  func setupRepositoryList(repository: Repository) {
    repositoryName.text = repository.nameRepository
    descriptionRepository.text = repository.descriptionRepository
    userName.text = repository.userRepository?.userLogin
    guard let avatarURL = repository.userRepository?.avatarURL else { return }
    avatarImage.kf.setImage(with: avatarURL)
  }
}