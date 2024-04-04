//
//  LoginIntroView.swift
//  LMessenger
//
//  Created by 정정욱 on 4/4/24.
//

import SwiftUI

struct LoginIntroView: View {
    @State private var isPresentedLoginView: Bool = false
    var body: some View {
        NavigationStack{
            VStack(spacing: 20) {
                Spacer()
                Text("환영합니다.")
                    .font(.system(size: 26,weight: .bold))
                    .foregroundColor(.bkText)
                Text("무료 메시지와 영상통화, 음성통화를 부담없이 즐겨보세요")
                    .font(.system(size: 12))
                    .foregroundColor(.greyDeep)

                Spacer()

                Button{
                    isPresentedLoginView.toggle()
                }label: {
                    Text("로그인")
                }
                .buttonStyle(LoginBtnStyle(textColor: .lineAppColor))

            } // isPresented가 true일 시 아래 구문 실행
            .navigationDestination(isPresented: $isPresentedLoginView) {
                LoginView()
            }
        }
    }
}

#Preview {
    LoginIntroView()
}
