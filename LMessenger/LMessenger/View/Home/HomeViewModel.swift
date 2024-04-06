//
//  HomeViewModel.swift
//  LMessenger
//
//  Created by 정정욱 on 4/6/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var myUser: User?
    @Published var users: [User] = [.stub1, .stub2] // 친구목록 

}
