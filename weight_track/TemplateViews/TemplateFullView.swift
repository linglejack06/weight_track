//
//  TemplateFullView.swift
//  weight_track
//
//  Created by Jack Lingle on 7/29/24.
//

import SwiftUI

struct TemplateFullView: View {
    let template: WorkoutTemplate
    var setCount: Int {
        var count = 0
        for exercise in template.exercises {
            count += exercise.numOfSets
        }
        return count
    }
    
    var body: some View {
        List {
            Section {
                Text("Category: \(template.category)")
                    .font(.subheadline)
                Text("\(template.exercises.count) Exercises")
                    .font(.subheadline)
                Text("\(setCount) Total Sets")
                    .font(.subheadline)
            }
            Section("Exercises") {
                List(template.exercises) { exercise in
                    ExerciseRowView(exercise: exercise)
                }
            }
        }
        .navigationTitle(template.title)
        .toolbar {
            ToolbarItem {
                Button("Start Workout") {}
            }
        }
    }
}

#Preview {
    TemplateFullView(template: sampleWorkoutTemplate)
}
