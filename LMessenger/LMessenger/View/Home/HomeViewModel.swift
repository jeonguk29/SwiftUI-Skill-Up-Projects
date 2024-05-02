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
        case load
        case requestContacts
        case presentMyProfile
        case presentOtherProfile(String)
    }
    
    @Published var myUser: User?
    @Published var users: [User] = [] // 친구목록
    @Published var phase: Phase = .notRequested
    @Published var modalDestination: HomeModalDestination?
    
    
    var userId: String
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
    }
    
    
    func send(action: Action) {
        switch action {
        case .load:
            phase = .loading
            
            container.services.userService.getUser(userId: userId)
                .handleEvents(receiveOutput: { [weak self] user in
                    // stream 이벤트 중간에 작업을 하고 싶은 경우 사용
                    self?.myUser = user
                })
                .flatMap { user in
                    self.container.services.userService.loadUsers(myId: user.id)
                }
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] users in
                    self?.users = users
                    self?.phase = .success
                }
                .store(in: &subscriptions)
        case .requestContacts:
            container.services.contactService.fetchContacts()
            // 유저 정보 불러왔으면 이 정보를 DB에 넣어야함
                .flatMap { users in
                    self.container.services.userService.addUserAfterContact(users: users)
                }
                .flatMap { _ in
                    self.container.services.userService.loadUsers(myId: self.userId)
                }
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] users in
                    self?.users = users
                    self?.phase = .success
                }
                .store(in: &subscriptions)
        case .presentMyProfile:
            modalDestination = .myProfile
        case let .presentOtherProfile(userId):
            modalDestination = .otherProfile(userId)
        }
    }
}
