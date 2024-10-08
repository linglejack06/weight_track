//
//  TemplateFullView.swift
//  weight_track
//
//  Created by Jack Lingle on 7/29/24.
//

import SwiftUI
import SwiftData

struct TemplateFullView: View {
    @Environment(\.modelContext) var modelContext
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
            if workout.template == template && workout.isComplete {
                count += 1
            }
        }
        return count
    }
    
    
    @State private var presentProgress = false
    @State private var hasStartError = false
    @State private var activeWorkout: ActiveWorkout? = nil
    @State private var currentExercise: ActiveExercise? = nil
    
    func updatePresentProgress () {
        for workout in activeWorkouts {
            if !workout.isComplete {
                // show an eror alert
                hasStartError = true
                return
            }
        }
        
        activeWorkout = ActiveWorkout(template: template)
        currentExercise = ActiveExercise(template: template.exercises[0])
        
        if let unwrappedWorkout = activeWorkout {
            if let unwrappedExercise = currentExercise {
                modelContext.insert(unwrappedWorkout)
                modelContext.insert(unwrappedExercise)
                unwrappedWorkout.exercises.append(unwrappedExercise)
                presentProgress = true
            }
        } else {
            hasStartError  = true;
            return;
        }
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
//                        Text("Most Recent: \(mostRecentCompletion?.formatted(date: .numeric, time: .omitted) ?? "None")")
//                            .font(.headline)
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
                Button("Start", action: updatePresentProgress)
                    .font(.title2)
            }
        }
        .fullScreenCover(isPresented: $presentProgress) {
            if let unwrappedWorkout = activeWorkout {
                if let unwrappedExercise = currentExercise {
                    ProgressView(activeWorkout: unwrappedWorkout, currentExercise: unwrappedExercise)
                }
            }
        }
        .alert("Error", isPresented: $hasStartError) {
            Button("OK") {}
        } message: {
            Text("There is already a workout in progress. Delete or finish to start a new one")
        }
    }
}
