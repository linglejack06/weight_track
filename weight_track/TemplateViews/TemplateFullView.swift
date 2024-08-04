//
//  TemplateFullView.swift
//  weight_track
//
//  Created by Jack Lingle on 7/29/24.
//

import SwiftUI

struct TemplateFullView: View {
    @Environment (\.modelContext) var modelContext
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
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(template.exercises.count) Exercises")
                            .font(.headline)
                        Text("\(setCount) Total Sets")
                            .font(.headline)
                    }
                    Spacer()
                    VStack (alignment: .leading) {
                        Text("Completed Workouts")
                        Text("Most Recent Completion")
                    }
                }
            }
            .listRowSeparator(.hidden)
            Section("Exercises") {
                List(template.exercises) { exercise in
                    ExerciseRowView(exercise: exercise)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(template.title)
                    Text("Category: \(template.category)")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondary)
                }
            }
            ToolbarItem {
                NavigationLink {
                    ProgressView(template: template, context: modelContext)
                } label: {
                    Text("Start Workout")
                }
            }
        }
    }
}
