//
//  Time.swift
//  voiceMemo
//

import Foundation

struct Time {
    var hours: Int
    var minutes: Int
    var seconds: Int
    
    var convertedSeconds: Int { // 변환 전부 초로 변환 피커에서 사용하기 위해
        return (hours * 3600) + (minutes * 60) + seconds
    }
    
    
    // 초를 통해서 다시 시, 분, 초 표시해주기
    static func fromSeconds(_ seconds: Int) -> Time {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = (seconds % 3600) % 60
        return Time(hours: hours, minutes: minutes, seconds: remainingSeconds)
    }
}
