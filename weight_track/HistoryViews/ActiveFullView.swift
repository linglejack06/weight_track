//
//  ActiveFullView.swift
//  weight_track
//
//  Created by Jack Lingle on 8/6/24.
//

import SwiftUI
import SwiftData

struct ActiveFullView: View {
    @Environment(\.modelContext) var modelContext
    let workout: ActiveWorkout
    

    var body: some View {
        List {
            Section {
                Text("Completed: \(workout.date.formatted(.dateTime.day().month().year())) at \(workout.date.formatted(date: .omitted,time: .shortened))")
            }
            ForEach(workout.exercises) { exercise in
                ExerciseFullView(exercise: exercise)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(workout.template.title)
                    Text("Category: \(workout.template.category)")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondary)
                }
            }
        }
    }
}

