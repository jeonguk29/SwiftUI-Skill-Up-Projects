//
//  UserObject.swift
//  LMessenger
//
//  Created by 정정욱 on 4/7/24.
//

import Foundation

// 실제 DB에 값을 넣기 위한 규격 == DTO 틀을 만듬
// 우리 프로젝트에서 모델과 DTO 규격은 다르지 않지만 좀더 실무적으로 이렇식으로 구현함 
struct UserObject: Codable {
    var id: String
    var name: String
    var phoneNumber: String?
    var profileURL: String?
    var description: String?
}

// 서버에서 받은 DTO를 클라에서 사용하기 위한 모델로 바꾸는 로직 
extension UserObject {
    func toModel() -> User {
        .init(
            id: id,
            name: name,
            phoneNumber: phoneNumber,
            profileURL: profileURL,
            description: description
        )
    }
}
