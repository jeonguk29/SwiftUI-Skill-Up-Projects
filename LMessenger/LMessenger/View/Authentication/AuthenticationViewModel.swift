//
//  AuthenticationViewModel.swift
//  LMessenger
//
//  Created by 정정욱 on 4/3/24.
//

import Foundation
import Combine
import AuthenticationServices


// 인증을 나타내는 상태를 viewmodel에 추가하여 앱이 실행됐을 때 AuthenticationView에서 상태에따라 뷰를 분기하는 작업
enum AuthenticationState {
    case unauthenticated // 비인증 상태
    case authenticated // 인증 상태
}


class AuthenticationViewModel: ObservableObject {
    // 뷰에서 원하는 액션 처리
    enum Action {
        case checkAuthenticationState
        case googleLogin
        case appleLogin(ASAuthorizationAppleIDRequest)
        case appleLoginCompletion(Result<ASAuthorization, Error>)
        case logout
    }
    
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var isLoading: Bool = false
    
    var userId: String?
    private var subscriptions = Set<AnyCancellable>()
    /* sink 했을때 subscription 리턴 된다고 했음
     subscription을 ViewModel에서 관리할것임 하지만 ViewModel에서 구독이 하나만 이루어지는게 아니기때문에 subscription을 Set을 통해 관리해줄것임
     */
    private var currentNonce: String?
    
    //서비스에 접근할수있도록 연결해주는 작업
    //DIContainer를 통해서 서비스 접근 예정이여서 init에 container를 받아서 viewmodel에 넣어줌
    private var container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
            // 자동 로그인 체크 userId 있다면 로그인 연결 된거라 authenticated 인증 상태로 넣어주기
        case .checkAuthenticationState:
            if let userId = container.services.authService.checkAuthenticationState() {
                self.userId = userId
                self.authenticationState = .authenticated
            }
            
            // 구글 로그인, 파이어베이스 로직 실행
        case .googleLogin:
            isLoading = true // ProgressView 보여주기
            
            container.services.authService.signInWithGoogle()
                .sink { [weak self] completion in
                    // TODO: 실패시 작업
                    if case .failure = completion {
                        self?.isLoading = false
                        // 실패시 일단 프로그래스 뷰 멈추고 경고창 같은거 보여주는 작업 추가적으로 가능함
                    }
                } receiveValue: { [weak self] user in
                    self?.isLoading = false // 성공시 ProgressView 멈추기
                    self?.userId = user.id // 유저 정보오면 뷰모델에서 id 같도록 함
                    self?.authenticationState = .authenticated
                }
                .store(in: &subscriptions) // 해당 메서드를 통해 연결해주면 해당 구독권들이 추가될것임
            
        case let .appleLogin(request):
            let nonce = container.services.authService.handleSignInWithAppleRequest(request)
            currentNonce = nonce
        case let .appleLoginCompletion(result):
            // result 로그인 성공시 인증 정보가 있음 이걸 추출해서 서비스에 넘겨줄것임
            if case let .success(authorization) = result {
                guard let nonce = currentNonce else { return }
                
                container.services.authService.handleSignInWithAppleCompletion(authorization, nonce: nonce)
                    .sink { [weak self] completion in
                        if case .failure = completion {
                            self?.isLoading = false
                        }
                    } receiveValue: { [weak self] user in
                        self?.userId = user.id
                        self?.authenticationState = .authenticated
                        self?.isLoading = false
                    }
                    .store(in: &subscriptions)
            } else if case let .failure(error) = result {
                print(error.localizedDescription)
                isLoading = false
            }
        case .logout:
            container.services.authService.logout()
                .sink { completion in
                    
                } receiveValue: { [weak self] _ in
                    self?.authenticationState = .unauthenticated // 결과 오면 비인증으로 만들고
                    self?.userId = nil // 초기화 
                }
            
        }
    }
}
