//
//  HistoryView.swift
//  weight_track
//
//  Created by Jack Lingle on 8/4/24.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query private var workouts: [ActiveWorkout]
    
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
                    NavigationLink {
                        ProgressView(activeWorkout: activeWorkout!)
                    } label: {
                        ActiveCardView(activeWorkout: activeWorkout!)
                    }
                }
            }
        }
    }
}

#Preview {
    HistoryView()
}
