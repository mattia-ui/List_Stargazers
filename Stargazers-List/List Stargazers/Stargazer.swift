//
//  Stargazer.swift
//  List Stargazers
//
//  Created by Mattia Cardone on 22/02/2021.
//  Copyright © 2021 Mattia Cardone. All rights reserved.
//

import Foundation

struct Stargazer: Codable {
    let username: String
    let avatar: String

    init(username: String, avatar: String) {
        self.username = username
        self.avatar = avatar
    }

    private enum CodingKeys : String, CodingKey {
        case username = "login", avatar = "avatar_url"
    }
}
