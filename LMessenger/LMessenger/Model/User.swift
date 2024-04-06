//
//  User.swift
//  LMessenger
//
//  Created by 정정욱 on 4/5/24.
//

import Foundation

struct User {
    var id: String
    var name: String
    var phoneNumber: String?
    var profileURL: String?
    var description: String?
}


// 친구목록 더미
extension User {
    static var stub1: User {
        .init(id: "user1_id", name: "최도영")
    }

    static var stub2: User {
        .init(id: "user2_id", name: "최라떼")
    }
}
