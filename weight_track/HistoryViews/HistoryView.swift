//
//  HistoryView.swift
//  weight_track
//
//  Created by Jack Lingle on 8/4/24.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var workouts: [ActiveWorkout]
    @State private var presentProgress = false
    
    var activeWorkout: ActiveWorkout? {
        for workout in workouts {
            if Calendar.current.isDateInToday(workout.date) && !workout.isComplete {
                return workout
            }
        }
        return nil
    }
    var body: some View {
        List {
            if (activeWorkout != nil) {
                Section("Incomplete Workout") {
                    Button { presentProgress = true } label: {
                        ActiveCardView(activeWorkout: activeWorkout!)
                    }
                }
                .fullScreenCover(isPresented: $presentProgress) {
                    ProgressView(activeWorkout: self.activeWorkout!, context: modelContext)
                }
            }
        }
    }
}

#Preview {
    HistoryView()
}
