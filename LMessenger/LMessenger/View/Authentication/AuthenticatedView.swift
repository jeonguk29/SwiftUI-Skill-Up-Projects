//
//  AuthenticatedView.swift
//  LMessenger
//
//

import SwiftUI

struct AuthenticatedView: View {
    @StateObject var authViewModel: AuthenticationViewModel
    var body: some View {
        ///인증을 나타내는 상태를 viewmodel에 추가하여 앱이 실행됐을 때 AuthenticationView에서 상태에따라 뷰를 분기하는 작업
        switch authViewModel.authenticationState {
        case .unauthenticated:
            // TODO: loginView
            LoginIntroView()
        case .authenticated:
            // TODO: mainTabView
            MainTabView()
        }
    }
}

#Preview {
    AuthenticatedView(authViewModel: .init(container: .init(service:  StubService())))
}
