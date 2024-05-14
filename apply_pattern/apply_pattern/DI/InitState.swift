//
//  InitState.swift
//  apply_pattern
//
//  Created by Moonbeom KWON on 2023/11/16.
//

import UIKit

// 추상화 작업을 했으니 하위 모듈에서 구현
class InitState: State {
    var presentor: Presentor
    var nextState: State {
        return RunState(presentor: self.presentor)
    }

    init(presentor: Presentor) {
        self.presentor = presentor
    }

    func updateUI() {
        do { }
    }
}
