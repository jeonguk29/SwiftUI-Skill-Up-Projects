//
//  DIContainer.swift
//  LMessenger
//
//  Created by 정정욱 on 4/3/24.
//

import Foundation
// @EnvironmentObject 에 주입이 될 예정임
class DIContainer: ObservableObject {
    var services: ServiceType
    
    init(service: ServiceType) {
        self.services = service
    }
}
