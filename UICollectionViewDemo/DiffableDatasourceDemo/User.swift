//
//  Section.swift
//  UICollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/12/06.
//

import UIKit

class User: Hashable {
    
    var id = UUID()
    var userName: String
    var tweets: [Tweet]
    
    init(userName: String, tweets: [Tweet]) {
        self.userName = userName
        self.tweets = tweets
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

extension User {
    static var allUsers: [User] =  [
        User(userName: "Taro",
                tweets: Tweet.demoTweets()),
        User(userName: "Jiro",
                tweets: Tweet.demoTweets()),
        User(userName: "Saburo",
                tweets: Tweet.demoTweets()),
        User(userName: "Shiro",
                tweets: Tweet.demoTweets()),
        User(userName: "Goro",
                tweets: Tweet.demoTweets())
    ]
}
