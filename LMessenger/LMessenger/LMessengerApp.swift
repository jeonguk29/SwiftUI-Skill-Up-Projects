//
//  LMessengerApp.swift
//  LMessenger
//
//

import SwiftUI

@main
struct LMessengerApp: App {
    @StateObject var container: DIContainer = .init(service: Services()) // 전역적으로 주입해서 사용할것임
    var body: some Scene {
        WindowGroup {
            AuthenticatedView()
                .environmentObject(container)
        }
    }
}
