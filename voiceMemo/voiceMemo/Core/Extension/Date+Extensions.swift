//
//  Date+Extensions.swift
//  voiceMemo
//

import Foundation

extension Date {
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 한국시간 기준
        formatter.dateFormat = "a hh:mm" // 오전/오후, 시간, 분
        return formatter.string(from: self)
    }
    
    // 오늘인지 아니면 오늘 기준 이전 날짜인지 파악해주는 변수
    var formattedDay: String {
        let now = Date()
        let calendar = Calendar.current // 현재 날짜
        
        let nowStartOfDay = calendar.startOfDay(for: now)
        let dateStartOfDay = calendar.startOfDay(for: self) // 현재 들어온 날짜
        
        // 날짜 차이가 얼마나 나는지 담는 변수
        let numOfDaysDifference = calendar.dateComponents([.day], from: nowStartOfDay, to: dateStartOfDay).day!
        /*
         날짜 사이의 일 수 차이가 들어갑니다. 이 값은 두 날짜의 날짜 차이를 나타내며, 이를 기반으로 날짜가 오늘인지, 아니면 이전 날짜인지를 판별하여 문자열을 반환하는데 사용
         */
        
        if numOfDaysDifference == 0 {
            return "오늘"
        } else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "M월 d일 E요일"
            return formatter.string(from: self)
        }
    }
    
    // 음성 메모에서 사용할 속성
    var fomattedVoiceRecorderTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.M.d"
        return formatter.string(from: self)
    }
}
