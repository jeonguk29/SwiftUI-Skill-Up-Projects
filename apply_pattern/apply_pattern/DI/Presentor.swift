//
//  Presentor.swift
//  apply_pattern
//
//  Created by Moonbeom KWON on 2023/11/16.
//

import UIKit

// 프로토콜 이용해서 추상화 된 인터페이스 생성
protocol State {
    var presentor: Presentor { get } // 화면 바꾸기 위한 UI요소가 담기는 컨테이너
    var nextState: State { get } // State 패턴의 특징 중 하나 내가 어떤 다음 상태로 갈 수 있는지 알 수 있음

    func updateUI()
}

class Presentor {
    // 접근 제어 연산자가 중요한 이유는 협업할때 접근 통로를 만들어주는 것임 private 내부에서만 써라 나머지는 외부에서 접근해도 괜찮다.
    
    var timeLabel: UILabel
    var actionButton: UIButton

    private var startDate: Date?
    private var stopDate: Date?
    private var timer: Timer?

    var isSuspended: Bool { // 일시정지 상태
        return self.startDate != nil && self.stopDate != nil
    }

    init(timeLabel: UILabel, actionButton: UIButton) {
        self.timeLabel = timeLabel
        self.actionButton = actionButton
    }
}

// 확장으로 비즈니스 로직 빼기 extension으로 구현된 메서드들은 다이나믹 디스패치가 아니라 스테틱 디스패치로 실행해서 실제로 속도가 빨라짐 
extension Presentor {
    func getStartDate() -> Date? {
        return self.startDate
    }

    func setStartDate(_ date: Date) {
        self.startDate = date
    }

    func getStopDate() -> Date? {
        return self.stopDate
    }

    func setStopDate(_ date: Date?) {
        self.stopDate = date
    }
}

extension Presentor {
    func scheduleTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.01,
                                          target: self,
                                          selector: #selector(updateTimeLabel),
                                          userInfo: nil,
                                          repeats: true)
    }

    func invalidateTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }

    @objc private func updateTimeLabel() {
        guard let startDate = self.startDate else {
            self.timeLabel.text = "Time Label"
            return
        }

        if let stopDate = self.stopDate {
            let timeInterval = stopDate.timeIntervalSince(startDate)
            let str = String(format: "%.2f", timeInterval)
            self.timeLabel.text = "\(str) s"
        } else {
            let timeInterval = Date().timeIntervalSince(startDate)
            let str = String(format: "%.2f", timeInterval)
            self.timeLabel.text = "\(str) s"
        }
    }
}
