//
//  StopState.swift
//  apply_pattern
//
//  Created by Moonbeom KWON on 2023/11/16.
//

import UIKit

class StopState: State {
    var presentor: Presentor
    var nextState: State {
        return RunState(presentor: self.presentor)
    }

    init(presentor: Presentor) {
        self.presentor = presentor
    }

    func updateUI() {
        self.presentor.setStopDate(Date()) // 현재 멈춘시간
        self.presentor.invalidateTimer() // 타이머 죽여주기 
        self.presentor.actionButton.setTitle("재시작", for: .normal)
    }
}
