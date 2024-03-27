//
//  voiceMemoApp.swift
//  voiceMemo
//

import SwiftUI

@main
struct voiceMemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    // 이렇게 해줘야지 SwiftUI에서 앱델리게이트를 사용할 수 있음
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
    }
}
