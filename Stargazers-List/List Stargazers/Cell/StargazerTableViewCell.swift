//
//  StargazerTableViewCell.swift
//  List Stargazers
//
//  Created by Mattia Cardone on 23/02/21.
//  Copyright © 2021 Mattia Cardone. All rights reserved.
//

import UIKit

class StargazerTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!

    func configure(_ stargazer: Stargazer) {
        self.usernameLabel.text = stargazer.username
        self.avatarImageView.downloadedFrom(link: stargazer.avatar)
    }
}

private extension UIImageView {
    private func downloadedFrom(url: URL, contentMode mode: UIViewContentMode) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
        }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
