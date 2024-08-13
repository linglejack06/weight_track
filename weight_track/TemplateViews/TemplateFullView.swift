//
//  TemplateFullView.swift
//  weight_track
//
//  Created by Jack Lingle on 7/29/24.
//

import SwiftUI
import SwiftData

struct TemplateFullView: View {
    @Environment (\.modelContext) var modelContext
    @Query private var activeWorkouts: [ActiveWorkout]
    let template: WorkoutTemplate
    var setCount: Int {
        var count = 0
        for exercise in template.exercises {
            count += exercise.numOfSets
        }
        return count
    }
    
    var completionTimes: Int {
        var count = 0
        for workout in activeWorkouts {
            if workout.template == template {
                count += 1
            }
        }
        return count
    }
    
    var mostRecentCompletion: Date? {
        var sortedWorkouts = activeWorkouts.sorted(by: { $0.date > $1.date })
        return activeWorkouts.filter({$0.template == template}).first?.date
    }
    
    @State private var presentProgress = false
    @State private var hasStartError = false
    
    func updatePresentProgress () {
        for workout in activeWorkouts {
            if Calendar.current.isDateInToday(workout.date) && !workout.isComplete {
                // show an eror alert
                hasStartError = true
                return
            }
        }
        
        presentProgress = true
    }
    
    var body: some View {
        List {
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(template.exercises.count) Exercise" + (template.exercises.count > 1 ? "s" : ""))
                            .font(.headline)
                        Text("\(setCount) Total Set" + (setCount > 1 ? "s" : ""))
                            .font(.headline)
                    }
                    Spacer()
                    VStack (alignment: .leading) {
                        Text("Completions: \(completionTimes)")
                            .font(.headline)
                        Text("Most Recent: \(mostRecentCompletion?.formatted(date: .numeric, time: .omitted) ?? "None")")
                            .font(.headline)
                    }
                }
            }
            .listRowSeparator(.hidden)
            Section("Exercises") {
                ForEach(template.exercises) { exercise in
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
                Button("Start Workout", action: updatePresentProgress)
            }
        }
        .fullScreenCover(isPresented: $presentProgress) {
            ProgressView(template: template, context: modelContext)
        }
        .alert("Error", isPresented: $hasStartError) {
            Button("OK") {}
        } message: {
            Text("There is already a workout in progress for today. Delete to start a new one")
        }
    }
}
