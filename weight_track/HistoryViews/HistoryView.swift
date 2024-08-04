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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    HistoryView()
}
