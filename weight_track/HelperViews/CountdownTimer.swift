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
    
    @State var timeRemaining: String
    var desiredDuration: Date
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    public init(duration: Double) {
        desiredDuration = Calendar.current.date(byAdding: .second, value: Int(duration), to: Date())!
        self._timeRemaining = .init(initialValue: CountdownTimer.durationFormatter.string(from: desiredDuration.timeIntervalSince(Date())) ?? "----")
    }
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                Spacer()
                Text(timeRemaining)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.red)
                Spacer()
            }
        }
        .onReceive(timer) { _ in
            var delta = desiredDuration.timeIntervalSince(Date())
            if delta <= 0 {
                delta = 0
                timer.upstream.connect().cancel()
            }
            timeRemaining = CountdownTimer.durationFormatter.string(from: delta) ?? "----"
        }
    }
}
