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

struct UserAndPostsModel: Encodable {
    let usersModel: UsersModel
    let postsModel: PostsModel
    
    enum CodingKeys: String, CodingKey {
        case avatar, name, title, body
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(usersModel.avatar, forKey: UserAndPostsModel.CodingKeys.avatar)
        try container.encode(usersModel.name, forKey: UserAndPostsModel.CodingKeys.name)
        try container.encode(postsModel.title, forKey: UserAndPostsModel.CodingKeys.title)
        try container.encode(postsModel.body, forKey: UserAndPostsModel.CodingKeys.body)
    }
}
