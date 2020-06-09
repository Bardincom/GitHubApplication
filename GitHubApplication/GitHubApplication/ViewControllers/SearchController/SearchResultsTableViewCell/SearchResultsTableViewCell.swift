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

    //    ActivityIndicator.start()

    avatarImage.layer.cornerRadius = avatarImage.bounds.height / 2
    //    avatarImage.backgroundColor = .yellow
  }

  func setupRepositoryList(repository: Repository) {
    repositoryName.text = repository.nameRepository
    descriptionRepository.text = repository.descriptionRepository
    userName.text = repository.userRepository?.userLogin
    //    print(repository.userRepository?.avatarURL)
    guard let avatarURL = repository.userRepository?.avatarURL else { return }
    avatarImage.kf.setImage(with: avatarURL)
    ActivityIndicator.stop()
  }

}

//let urlLogoImage = urlImage
//self.logoImageView.kf.setImage(with: urlLogoImage)
