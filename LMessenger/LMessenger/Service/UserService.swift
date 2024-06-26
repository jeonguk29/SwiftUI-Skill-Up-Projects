//
//  UserService.swift
//  LMessenger
//
//  Created by 정정욱 on 4/7/24.
//

import Foundation
import Combine

protocol UserServiceType {
    // 여기는서비스라 DTO가 아닌 User 모델을 받음 
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError>
    func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError>
    func getUser(userId: String) async throws -> User
    func getUser(userId: String) -> AnyPublisher<User, ServiceError>
    func loadUsers(myId: String) -> AnyPublisher<[User], ServiceError>
    func updateDescription(userId: String, description: String) async throws
}

class UserService: UserServiceType {

    private var dbRepository: UserDBRepositoryType //다 보면 프로토콜 타입을 초기화 받음
    // 실제 구현채와 의존성이 없어짐 다른 구현체도 주입 할수가 있음 느슨한 결합이 가능해짐 

    init(
        dbRepository: UserDBRepositoryType
    ) {
        self.dbRepository = dbRepository
    }
    
    // 선언형 프로그래밍을 보여주는 예시
    func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError> {
        dbRepository.addUserAfterContact(users: users.map { $0.toObject() }) // DTO 변환시켜 던지기
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
    // 사용자 파이어베이스 등록하기
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
        dbRepository.addUser(user.toObject()) // Model을 => DTO로
            .map { user } // User
            .mapError { .error($0) } // ServiceError 로 변환해서 던짐 
            .eraseToAnyPublisher()
    }

    // 로그인 사용자 정보 가져오기
    func getUser(userId: String) -> AnyPublisher<User, ServiceError> {
        dbRepository.getUser(userId: userId)
            .map { $0.toModel() } // 모델로 변경하고
            .mapError { .error($0) } // 서비스 에러로 변경 
            .eraseToAnyPublisher()
    }

    func getUser(userId: String) async throws -> User {
        let userObject = try await dbRepository.getUser(userId: userId)
        return userObject.toModel()
    }
    
    
    // 친구 목록 가져오가ㅣ
    func loadUsers(myId: String) -> AnyPublisher<[User], ServiceError> {
        dbRepository.loadUsers()
            .map { $0
                .map { $0.toModel() }
                .filter { $0.id != myId } // 필터를 사용해서 자기 자신은 제외 시키기 
            }
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
    func updateDescription(userId: String, description: String) async throws {
        try await dbRepository.updateUser(userId: userId, key: "description", value: description)
    }
   
}

class StubUserService: UserServiceType {
    func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    

    func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
        Empty().eraseToAnyPublisher()
    }

    func getUser(userId: String) -> AnyPublisher<User, ServiceError> {
        Just(.stub1)
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    func getUser(userId: String) async throws -> User {
        return .stub1
    }

    func loadUsers(myId: String) -> AnyPublisher<[User], ServiceError> {
        Just([.stub1, .stub2]) // 프리뷰에서 확인하기 위한 더미 데이터
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    func updateDescription(userId: String, description: String) async throws { }
}
