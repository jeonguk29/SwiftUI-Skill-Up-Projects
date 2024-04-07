//
//  Services.swift
//  LMessenger
//
//  Created by 정정욱 on 4/3/24.
//

import Foundation

protocol ServiceType {
    //인증 서브스 틀
    var authService: AuthenticationServiceType { get set }
    var userService: UserServiceType { get set }
}

class Services: ServiceType {
    var authService: AuthenticationServiceType
    var userService: UserServiceType
    init() {
        self.authService = AuthenticationService()
        self.userService = UserService(dbRepository: UserDBRepository())
    }
}

//preView 용
class StubService: ServiceType {
    var authService: AuthenticationServiceType = StubAuthenticationService()
    var userService: UserServiceType = StubUserService()
}
