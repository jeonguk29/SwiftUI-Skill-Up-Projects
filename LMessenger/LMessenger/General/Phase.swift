//
//  Phase.swift
//  LMessenger
//
//  Created by 정정욱 on 4/8/24.
//


import Foundation

enum Phase {
    case notRequested
    case loading // 로딩중인지
    case success // 로딩 성공했는지
    case fail // 로딩 실패 했는지 
}
