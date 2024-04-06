//
//  MainTabType.swift
//  LMessenger
//
//  Created by 정정욱 on 4/6/24.
//

import Foundation

enum MainTabType: String, CaseIterable { // CaseIterable란?
    case home
    case chat
    case phone

    var title: String {
        switch self {
        case .home:
            return "홈"
        case .chat:
            return "대화"
        case .phone:
            return "통화"
        }
    }

    func imageName(selected: Bool) -> String {
        selected ? "\(rawValue)_fill" : rawValue
    }
}
