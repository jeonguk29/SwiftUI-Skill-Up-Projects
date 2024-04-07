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

// User 객체를 오브젝트 객체로 바꾸는 기능을 확장으로 모델에 구현
extension User {
    func toObject() -> UserObject {
        .init(
            id: id,
            name: name,
            phoneNumber: phoneNumber,
            profileURL: profileURL,
            description: description
        )
    }
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
