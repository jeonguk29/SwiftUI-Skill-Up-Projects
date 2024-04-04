//
//  LoginView.swift
//  LMessenger
//
//  Created by 정정욱 on 4/4/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    
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
            }label: {
                Text("Google 로그인")
            }
            .buttonStyle(LoginBtnStyle(textColor: .bkText, borderColor: .greyLight))

            Button{
                // TODO: Apple
            }label: {
                Text("Apple 로그인")
            }
            .buttonStyle(LoginBtnStyle(textColor: .bkText, borderColor: .greyLight))
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
    }
}

#Preview {
    LoginView()
}
