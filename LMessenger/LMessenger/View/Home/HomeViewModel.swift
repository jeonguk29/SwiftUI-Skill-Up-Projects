//
//  HomeViewModel.swift
//  LMessenger
//
//  Created by 정정욱 on 4/6/24.
//

import Foundation
import Combine
class HomeViewModel: ObservableObject {
    
    enum Action {
        case getUser
    }
    
    @Published var myUser: User?
    @Published var users: [User] = [] // 친구목록
    
    private var userId: String
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
    }
    
    
    func send(action: Action) {
        switch action {
        case .getUser:
            container.services.userService.getUser(userId: userId)
                .sink { completion in
                    // Todo
                } receiveValue: { [weak self] user in
                    self?.myUser = user
                }.store(in: &subscriptions)
        }
    }
}
