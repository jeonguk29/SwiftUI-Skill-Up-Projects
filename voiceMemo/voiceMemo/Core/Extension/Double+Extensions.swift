//
//  Double+Extensions.swift
//  voiceMemo
//

import Foundation

extension Double {
    // 몇시 몇분을 표현해주기 위해 만든 속성 03:05 파일 데이터에서 나온 정보를 표시해주기 위함 
  var formattedTimeInterval: String {
    let totalSeconds = Int(self)
    let seconds = totalSeconds % 60
    let minutes = (totalSeconds / 60) % 60
    
    return String(format: "%02d:%02d", minutes, seconds)
  }
}
