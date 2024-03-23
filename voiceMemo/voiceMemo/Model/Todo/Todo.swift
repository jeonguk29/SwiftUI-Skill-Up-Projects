//
//  Todo.swift
//  voiceMemo
//

import Foundation

// Hashable를 채택하는 이유중 하나는 보통 ForEech에서 돌릴려고 채택함
struct Todo: Hashable {
    var title: String
    var time: Date
    var day: Date
    var selected: Bool
    
    var convertedDayAndTime: String {
        // ex 오늘 - 오후 03:00시에 알림 
        String("\(day.formattedDay) - \(time.formattedTime)에 알림")
    }
}
