//
//  AuthenticatedView.swift
//  LMessenger
//
//

import SwiftUI

struct AuthenticatedView: View {
    @StateObject var authViewModel: AuthenticationViewModel
    // 뷰 모델 생성 시점은 해당 뷰를 만들 때 생성할것임 뷰 모델에서 컨테이너를 생성할 때 주입해 줄 것이기 때문
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticatedView(authViewModel: .init())
    }
}
