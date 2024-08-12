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
    @Query private var exercises: [ActiveExercise]
    let workout: ActiveWorkout
    var body: some View {
        List {
            Section {
                Text("Completed on \(workout.date.formatted(.dateTime.day().month().year()))")
            }
            Section ("Exercises") {
                ForEach(workout.exercises) { exercise in
                    NavigationLink {
                        ExerciseFullView(exercise: exercise, exercises: exercises)
                    } label: {
                        ExerciseRowView(exercise: exercise.template)
                    }
                }
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

