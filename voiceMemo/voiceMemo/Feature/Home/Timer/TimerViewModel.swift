//
//  TimerViewModel.swift
//  voiceMemo
//

import Foundation
import UIKit

class TimerViewModel: ObservableObject {
    @Published var isDisplaySetTimeView: Bool
    @Published var time: Time
    @Published var timer: Timer?
    @Published var timeRemaining: Int
    @Published var isPaused: Bool // 시간 일시 정지를 위한
    var notificationService: NotificationService
    
    init(
      isDisplaySetTimeView: Bool = true,
      time: Time = .init(hours: 0, minutes: 0, seconds: 0),
      timer: Timer? = nil,
      timeRemaining: Int = 0,
      isPaused: Bool = false,
      notificationService: NotificationService = .init()
    ) {
      self.isDisplaySetTimeView = isDisplaySetTimeView
      self.time = time
      self.timer = timer
      self.timeRemaining = timeRemaining
      self.isPaused = isPaused
      self.notificationService = notificationService
    }
}

// 비지니스 로직
extension TimerViewModel {
    func settingBtnTapped() {
        isDisplaySetTimeView = false
        timeRemaining = time.convertedSeconds
        // 타이머 시작 메서드 호출
        startTimer()
    }
    
    func cancelBtnTapped() {
        // 타이머 종료 메서드 호출
        stopTimer()
        isDisplaySetTimeView = true
    }
    
    func pauseOrRestartBtnTapped() {
        // 일시 정지 버튼 누를때
        if isPaused {
            startTimer() // 멈춰 있다면 다시 시작
        } else {
            timer?.invalidate() // 멈춰 있지 않으면 초기화
            timer = nil
        }
        isPaused.toggle()
    }
}

// extension앞에 private 붙이면 내부에 메서드는 따로 private키워드 붙이지 않아도 자동으로 붙음
private extension TimerViewModel {
    
    // 타이머 시작 메서드
    func startTimer() {
        guard timer == nil else { return }
        
        var backgroundTaskID: UIBackgroundTaskIdentifier?
        // 앱이 백그라운드 전환했을때 일부 작업을 계속할 수 있게 해주는 메서드 이렇게 안하면
        // 백그라운드에서 타이머가 흐르지 않고 알림도 오지 않음
        backgroundTaskID = UIApplication.shared.beginBackgroundTask {
          if let task = backgroundTaskID {
            UIApplication.shared.endBackgroundTask(task)
            backgroundTaskID = .invalid
          }
        }
       
        timer = Timer.scheduledTimer(
            withTimeInterval: 1, // 1초마다 타이머 변경
            repeats: true
        ) { _ in
            if self.timeRemaining > 0 { // 시간이 흐를때마다 즉 시간이 남아있다면
                self.timeRemaining -= 1 // 시간 빼기
            } else {
                self.stopTimer() // 시간 없다면 종료
                self.notificationService.sendNotification()
                
                // 앱이 포그라운드 상태에서 알람 날아옴 하지만 백그라운드에서는 날아오지 못함 타이머가 안돌아서 
                // 아래 코드 때문에 백그라운드에서도 보낼 수 있음 
                if let task = backgroundTaskID {
                  UIApplication.shared.endBackgroundTask(task)
                  backgroundTaskID = .invalid
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
