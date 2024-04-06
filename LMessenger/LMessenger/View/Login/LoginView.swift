//
//  LoginView.swift
//  LMessenger
//
//  Created by 정정욱 on 4/4/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack(alignment: .leading) {

            Group {
                Text("로그인")
                    .font(.system(size: 30 ,weight: .bold))
                    .foregroundColor(.bkText)
                    .padding(.top,80)

                Text("아래 제공되는 서비스로 로그인을 해주세요")
                    .font(.system(size: 14))
                    .foregroundColor(.greyDeep)
            }
            .padding(.horizontal,30)

            Spacer()

            Button{
                // TODO: Google
                // 1. 구글 로그인 시작
                authViewModel.send(action: .googleLogin)
            }label: {
                Text("Google 로그인")
            }
            .buttonStyle(LoginBtnStyle(textColor: .bkText, borderColor: .greyLight))

            SignInWithAppleButton { request in
                // 인증 요청 시에 불리는 closure
                // request에 원하는 정보와 nonce 세팅
                authViewModel.send(action: .appleLogin(request))
            } onCompletion: { result in
                // 인증 완료 시에 불리는 closure
                // result가 성공 시 Firebase 로그인 시도
                authViewModel.send(action: .appleLoginCompletion(result))
            }
            .frame(height: 40)
            .padding(.horizontal, 15)
            .cornerRadius(5)
            
        }
        // 네비버튼 커스텀하게 만들기위해
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button{
                    dismiss()
                } label: {
                    Image("back")
                }
            }
        }
        // custom 백 버튼
        .overlay {
            // 로그인 진행중이면 프로그레스 보여주기 
            if authViewModel.isLoading {
                ProgressView()
            }
        }
    }
}

#Preview {
    LoginView()
}
