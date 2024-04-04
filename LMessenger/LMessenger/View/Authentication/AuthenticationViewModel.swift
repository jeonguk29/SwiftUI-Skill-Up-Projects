//
//  AuthenticationViewModel.swift
//  LMessenger
//
//  Created by 정정욱 on 4/3/24.
//

import Foundation

// 인증을 나타내는 상태를 viewmodel에 추가하여 앱이 실행됐을 때 AuthenticationView에서 상태에따라 뷰를 분기하는 작업
enum AuthenticationState {
    case unauthenticated // 비인증 상태
    case authenticated // 인증 상태
}
class AuthenticationViewModel: ObservableObject {
    //
    @Published var authenticationState: AuthenticationState = .unauthenticated

    //서비스에 접근할수있도록 연결해주는 작업
    //DIContainer를 통해서 서비스 접근 예정이여서 init에 container를 받아서 viewmodel에 넣어줌
    private var container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }
}
