//
//  HomeModalDestination.swift
//  LMessenger
//
//  Created by 정정욱 on 4/8/24.
//

import Foundation

enum HomeModalDestination: Hashable, Identifiable {
    case myProfile
    case otherProfile(String)

    var id: Int { hashValue }
}
