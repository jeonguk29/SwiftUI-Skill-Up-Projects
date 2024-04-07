//
//  UserDBRepository.swift
//  LMessenger
//
//  Created by 정정욱 on 4/7/24.
//

import Foundation
import Combine
import FirebaseDatabase

protocol UserDBRepositoryType {
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError>
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError>
    func loadUsers() -> AnyPublisher<[UserObject], DBError>
}

class UserDBRepository: UserDBRepositoryType {
    
    // root를 말함
    var db: DatabaseReference = Database.database().reference()
 
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError> {
        // object > data > dictionary
        Just(object) // 컴바인 연산자를 이용하여 체이닝해 바꿀 것임
        // object를 스트림으로 만들기 위해 Just() 감쌓기
            .compactMap { try? JSONEncoder().encode($0) } // Data화
            .compactMap { try? JSONSerialization.jsonObject(with:$0, options: .fragmentsAllowed) } // 딕셔너리화
            .flatMap { value in // DB Set 작업 리얼타임 데이터베이스 컴바인 지원하지 않음 flatMap안에 Future를 정의해서 스트림 이어줌
                Future<Void, Error> { [weak self] promise in // Users/userId/ ..
                    self?.db.child(DBKey.users).child(object.id).setValue(value) { error, _ in
                        // 컴플리션으로 에러, 응답값 주기
                        if let error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                }
            }
            .mapError { DBError.error($0) } // DBError로 변환해서 퍼블리셔로 보낼것임 
            .eraseToAnyPublisher()
    }

    
    // 유저 정보 DB에서 가져오기
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError> {
        Future<Any?, DBError> { [weak self] promise in
            // getData 한번만 읽어오는 메서드
            self?.db.child(DBKey.users).child(userId).getData { error, snapshot in
                // snapshot을 가져옴
                if let error {
                    promise(.failure(DBError.error(error)))
                } else if snapshot?.value is NSNull { // 사용자 정보가 없을경우
                    promise(.success(nil))
                } else {
                    promise(.success(snapshot?.value))
                }
            }
        }.flatMap { value in //snapshot?.value 또한 딕셔너리 형태임 값을 UserObject로 변환 하기
            if let value {
                return Just(value)
                    .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                    .decode(type: UserObject.self, decoder: JSONDecoder())
                    .mapError { DBError.error($0) }
                    .eraseToAnyPublisher()
            } else {
                return Fail(error: .emptyValue)
                    .eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }

    func loadUsers() -> AnyPublisher<[UserObject], DBError> {
        Future<Any?, DBError> { [weak self] promise in
            self?.db.child(DBKey.users).getData { error, snapshot in
                if let error {
                    promise(.failure(DBError.error(error)))
                } else if snapshot?.value is NSNull {
                    promise(.success(nil))
                } else {
                    promise(.success(snapshot?.value))
                }
            }
        }
        .flatMap { value in
            if let dic = value as? [String: [String: Any]] {
                return Just(dic)
                    .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                    .decode(type: [String: UserObject].self, decoder: JSONDecoder())
                    .map { $0.values.map { $0 as UserObject } }
                    .mapError { DBError.error($0) }
                    .eraseToAnyPublisher()
            } else if value == nil {
                return Just([])
                    .setFailureType(to: DBError.self)
                    .eraseToAnyPublisher()
            } else {
                return Fail(error: .invalidatedType).eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }
}
