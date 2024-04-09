//  ContactService.swift
//  LMessenger
//
//  Created by dodor on 11/28/23.
//

import Foundation
import Combine
import Contacts

enum ContactError: Error {
    case permissionDenied
}

protocol ContactServiceType {
    // 연락처 연동하기
    func fetchContacts() -> AnyPublisher<[User], ServiceError>
}

class ContactService: ContactServiceType {
    func fetchContacts() -> AnyPublisher<[User], ServiceError> {
        // 연락처 컴바인 제공안해서 컴플리션 작업하고 Future로 만들 것임
        Future { [weak self] promise in
            self?.fetchContacts {
                promise($0) // 결과 보낸걸
            }
        }
        .mapError { .error($0) } // 여기서 받아 다시 처리 
        .eraseToAnyPublisher()
    }

    private func fetchContacts(completion: @escaping (Result<[User], Error>) -> Void) {
        let store = CNContactStore() // 유저 연락처 DB
        // 권한 요청하기
        store.requestAccess(for: .contacts) { [weak self] granted, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard granted else {
                completion(.failure(ContactError.permissionDenied)) // 권한 없을시 에러
                return
            }
            
            // 실질적으로 유저 연락처 가져오는 메서드
            self?.fetchContacts(store: store, completion: completion)
        }
    }

    private func fetchContacts(store: CNContactStore, completion: @escaping (Result<[User], Error>) -> Void) {
        
        // 풀네임, 폰 넘버 가져오게 설정
        let keyToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]

        let request = CNContactFetchRequest(keysToFetch: keyToFetch)

        var users: [User] = []

        do {
            try store.enumerateContacts(with: request) { contact, _ in
                // 정상적으로 가져왔다면 포메팅 해주기
                let name = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
                let phoneNumber = contact.phoneNumbers.first?.value.stringValue

                let user: User = .init(id: UUID().uuidString,
                                       name: name,
                                       phoneNumber: phoneNumber)
                users.append(user)
            }
            completion(.success(users)) // 성공
        } catch {
            completion(.failure(error)) // 실패
        }
    }
}

class StubContactService: ContactServiceType {

    func fetchContacts() -> AnyPublisher<[User], ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
