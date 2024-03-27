//
//  AppDelegate.swift
//  voiceMemo
//

// SwiftUI에서 기본적으로 없기 때문에 필요하다면 이렇게 만들어 줄 수 있음
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
  var notificationDelegate = NotificationDelegate()
  
    // 앱이 실행되었을때 바로 notificationDelegate를 설정해줘서 시스템에서 사용가능하게 만들어 주기
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    UNUserNotificationCenter.current().delegate = notificationDelegate
    return true
  }
}
