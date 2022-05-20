//
//  PostsModel.swift
//  LeagueMobileChallenge
//
//  Created by Prabh on 2022-05-18.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import Foundation

struct UsersModel: Codable {
    var avatar: Thumbnail
    var name: String
}

struct Thumbnail:  Codable {
    var thumbnail: String
}

struct PostsModel: Codable {
    var title: String
    var body: String
}
