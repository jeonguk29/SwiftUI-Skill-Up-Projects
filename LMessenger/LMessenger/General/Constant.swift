//
//  Constant.swift
//  LMessenger
//
//  Created by 정정욱 on 4/7/24.
//

import Foundation

typealias DBKey = Constant.DBKey
// Constant.DBKey.users 이렇게 치는게 너무 길어서 별명 만들어줌 

enum Constant { }

extension Constant {
    struct DBKey {
        static let users = "Users"
        static let chatRooms = "ChatRooms"
        static let chats = "Chats"
    }
}
//? 열거형의 확장?
