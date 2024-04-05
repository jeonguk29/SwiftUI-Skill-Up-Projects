//
//  AuthenticationViewModel.swift
//  LMessenger
//
//  Created by 정정욱 on 4/3/24.
//

import Foundation
import Combine
// 인증을 나타내는 상태를 viewmodel에 추가하여 앱이 실행됐을 때 AuthenticationView에서 상태에따라 뷰를 분기하는 작업
enum AuthenticationState {
    case unauthenticated // 비인증 상태
    case authenticated // 인증 상태
}


class AuthenticationViewModel: ObservableObject {
    // 뷰에서 원하는 액션 처리
    enum Action {
         case googleLogin
     }
    
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    
    var userId: String?
    private var subscriptions = Set<AnyCancellable>()
    /* sink 했을때 subscription 리턴 된다고 했음
       subscription을 ViewModel에서 관리할것임 하지만 ViewModel에서 구독이 하나만 이루어지는게 아니기때문에 subscription을 Set을 통해 관리해줄것임
    */
    
    //서비스에 접근할수있도록 연결해주는 작업
    //DIContainer를 통해서 서비스 접근 예정이여서 init에 container를 받아서 viewmodel에 넣어줌
    private var container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
            // 구글 로그인, 파이어베이스 로직 실행
        case .googleLogin:
            container.services.authService.signInWithGoogle()
                .sink { completion in
                    // TODO: 실패시 작업
                } receiveValue: { [weak self] user in
                    self?.userId = user.id // 유저 정보오면 뷰모델에서 id 같도록 함
                }
                .store(in: &subscriptions) // 해당 메서드를 통해 연결해주면 해당 구독권들이 추가될것임
        }
    }
}
