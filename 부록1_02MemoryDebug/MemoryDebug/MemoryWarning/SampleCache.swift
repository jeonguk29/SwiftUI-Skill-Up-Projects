//
//  SampleCache.swift
//  MemoryDebug
//
//  Created by Lecture on 2023/12/05.
//

import Foundation
import UIKit
import Combine

class SampleCache {
    
    static let shared: SampleCache = .init()
    
    private var data: [Data] = []
    private var cancellables: Set<AnyCancellable> = []
    
    private init() {
        // 메모리 체크 3번째 방법 이렇게 구독해서 원하는 클래스에서 확인 가능함 SwiftUI에서는 주로 이 방법을
        /*
         유의 사항
         MemoryWarning을 캐치하는 곳이 원인이 아닐 수 있음 이곳으로 정보를 전달해 주기 위함임이 코드로 인해 즉 해당 영역에서 발생한 게 아닐 수 있다는 걸 알고 있어야 함 하지만 MemoryWarning 발생 시 메모리를 확보하기 위해서 해당 부분에 적절한 작업을 해줄 수도 있고 로그를 넣어 줄 수도 있음
         */
        NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)
            .sink { [weak self] _ in
                print("캐시 clear")
                self?.clear()
            }
            .store(in: &self.cancellables)
    }
    
    func add(data: Data) {
        self.data.append(data)
    }
    
    func clear() {
        self.data.removeAll()
    }
    
}
