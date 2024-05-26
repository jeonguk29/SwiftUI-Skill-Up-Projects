//
//  TaskSample.swift
//  MemoryDebug
//
//  Created by Lecture on 2023/12/05.
//

import Foundation

class TaskSample {
    
    func doSomething() {
        // 캡처 리스트 적용하지 않아서 끝까지 불리게 되는 것임 이런 차이점이 있어서 무분별하게 캡처리스트 사용하는 것이 아니라 정말 필요한 경우에 잘 사용할 수 있도록 고민해봐야함 
//        Task {
//            do {
//                try await self.getSomething()
//                self.printSomething()
//                print("finished")
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
        
        Task { [weak self] in
            do {
                try await self?.getSomething()
                self?.printSomething()  // 이 경우 getSomething이 끝나기전에 TaskSample 인스턴스가 사라지면 printSomething이 불리지 않게됨.
                print("finished")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getSomething() async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000 * 10)
    }
    
    private func printSomething() {
        print("job finished")
    }
}
