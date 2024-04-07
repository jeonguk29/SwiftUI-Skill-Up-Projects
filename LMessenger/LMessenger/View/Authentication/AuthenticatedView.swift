//
//  AuthenticatedView.swift
//  LMessenger
//
//

import SwiftUI

struct AuthenticatedView: View {
    @StateObject var authViewModel: AuthenticationViewModel
    var body: some View {
        VStack {
            ///인증을 나타내는 상태를 viewmodel에 추가하여 앱이 실행됐을 때 AuthenticationView에서 상태에따라 뷰를 분기하는 작업
            switch authViewModel.authenticationState {
            case .unauthenticated:
                // TODO: loginView
                LoginIntroView()
                    .environmentObject(authViewModel)
            case .authenticated:
                // TODO: mainTabView
                MainTabView()
                    .environmentObject(authViewModel)
            }
        }
        .onAppear { // 상태가 업데이트 되었다고 하면 해당 상태에 따라 분기 처리 가능함
            authViewModel.send(action: .checkAuthenticationState)
            //authViewModel.send(action: .logout)
        }
    }
}

#Preview {
    AuthenticatedView(authViewModel: .init(container: .init(service:  StubService())))
}
