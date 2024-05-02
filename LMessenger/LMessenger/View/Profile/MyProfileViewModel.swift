//
//  MyProfileViewModel.swift
//  LMessenger
//
//  Created by 정정욱 on 4/30/24.
//

import Foundation

@MainActor
class MyProfileViewModel: ObservableObject {

    @Published var userInfo: User?
    @Published var isPresentedDescEditView: Bool

    private let userId: String
    private var container: DIContainer

    init(
        userInfo: User? = nil,
        userId: String,
        container: DIContainer,
        isPresentedDescEditView: Bool = false
    ) {
        self.userInfo = userInfo
        self.userId = userId
        self.container = container
        self.isPresentedDescEditView = isPresentedDescEditView
    }

    func getUser() async {
        if let user = try? await container.services.userService.getUser(userId: userId) {
            userInfo = user
        }
    }

    func updateDescription(_ description: String) async {
        do {
            try await container.services.userService.updateDescription(userId: userId, description: description)
            userInfo?.description = description
        } catch {
        }
    }
}
