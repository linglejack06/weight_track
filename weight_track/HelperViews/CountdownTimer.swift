//
//  CountdownTimer.swift
//  weight_track
//
//  Created by Jack Lingle on 9/17/24.
//

import SwiftUI

struct CountdownTimer: View {
    static var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropLeading
        return formatter
    }()
    
    @Environment(\.scenePhase) var scenePhase
    @StateObject var timer: RestTimer
    var notificationDate: Date = Date()
    var desiredDuration: Double
    
    init(desiredDuration: Double) {
        self.desiredDuration = desiredDuration
        self._timer = .init(wrappedValue: RestTimer(duration: desiredDuration))
    }
    
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                Spacer()
                if(Int(timer.secondsRemaining / 60) > 0) {
                    if(Int(timer.secondsRemaining.truncatingRemainder(dividingBy: 60)) > 0) {
                        Text("Rest: \(Int(timer.secondsRemaining / 60))m \(Int(timer.secondsRemaining.truncatingRemainder(dividingBy: 60)))s")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.red)
                    } else {
                        Text("Rest: \(Int(timer.secondsRemaining / 60))m")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.red)
                    }
                } else if (Int(timer.secondsRemaining.truncatingRemainder(dividingBy: 60)) > 0) {
                    Text("Rest: \(Int(timer.secondsRemaining.truncatingRemainder(dividingBy: 60)))s")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.red)
                } else {
                    Text("Rest: none")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.red)
                }
                Spacer()
            }
        }
        .onAppear() {
            timer.start()
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == .background || newValue == .inactive {
                timer.pause()
            }
            if newValue == .active {
                timer.start();
            }
        }
    }
}
