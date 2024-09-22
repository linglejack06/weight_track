//
//  RestTimer.swift
//  weight_track
//
//  Created by Jack Lingle on 9/17/24.
//

import Foundation
import SwiftUI

class RestTimer: ObservableObject {
    @Published var secondsElapsed: Double = 0
    @Published var secondsRemaining: Double
    var timer: Timer = Timer()
    var currentDate: Date = Date()
    var lastDateObserved: Date = Date()
    
    init(duration: Double) {
        self.secondsRemaining = duration
    }

    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.secondsElapsed += 1
            self.secondsRemaining -= 1
        }
        
        if (secondsElapsed > 1) {
            currentDate = Date()
            let accumulatedSeconds = Double(currentDate.timeIntervalSince(lastDateObserved))
            self.secondsElapsed += accumulatedSeconds
            self.secondsRemaining -= accumulatedSeconds
            lastDateObserved = currentDate
        }
    }

    func stop() {
        timer.invalidate()
        secondsElapsed = 0
        secondsRemaining = 0
    }

    func pause() {
        timer.invalidate()
        lastDateObserved = Date()
    }
}
