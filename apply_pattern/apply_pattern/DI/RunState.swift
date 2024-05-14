//
//  RunState.swift
//  apply_pattern
//
//  Created by Moonbeom KWON on 2023/11/16.
//

import UIKit

class RunState: State {
    var presentor: Presentor
    var nextState: State {
        return StopState(presentor: self.presentor)
    }

    init(presentor: Presentor) {
        self.presentor = presentor
    }

    func updateUI() {
        if self.presentor.isSuspended,
           let startDate = self.presentor.getStartDate(),
           let stopDate = self.presentor.getStopDate() {

            let suspendedInterval = Date().timeIntervalSince(stopDate)
            let newStartDate = startDate.addingTimeInterval(suspendedInterval)
            self.presentor.setStartDate(newStartDate)
            self.presentor.setStopDate(nil)
            self.presentor.scheduleTimer()
            self.presentor.actionButton.setTitle("정지", for: .normal)
        } else {
            self.presentor.setStartDate(Date())
            self.presentor.scheduleTimer()
            self.presentor.actionButton.setTitle("정지", for: .normal)
        }
    }
}
