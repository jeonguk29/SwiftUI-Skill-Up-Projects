//
//  NotificationService.swift
//  voiceMemo
//

import UserNotifications

// 외부에서 주입해서 사용하게 구현 
struct NotificationService {
    
    // 알림 보내기
    func sendNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted { // 허용이 되어 있다면
                let content = UNMutableNotificationContent()
                content.title = "타이머 종료!"
                content.body = "설정한 타이머가 종료되었습니다."
                content.sound = UNNotificationSound.default
                
                // 언제 알림 발생할지
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                
                // 알림 요청 생성 객체
                let request = UNNotificationRequest(
                    identifier: UUID().uuidString,
                    content: content,
                    trigger: trigger
                )
                
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
}


// 실제 알림 사용자가 받고 난 이후 컴플리션 핸들러로 반응을 확인 하기 위해 UNUserNotificationCenterDelegate를 채택
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}
