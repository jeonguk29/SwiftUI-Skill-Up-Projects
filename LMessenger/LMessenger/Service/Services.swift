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
}

class Services: ServiceType {
    var authService: AuthenticationServiceType

    init() {
        self.authService = AuthenticationService()
    }
}
//preView 용
class StubService: ServiceType {
    var authService: AuthenticationServiceType = StubAuthenticationService()


}
