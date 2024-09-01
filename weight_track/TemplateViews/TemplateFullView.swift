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
    
    var completionTimes: Int = 0
//        var count = 0
//        for workout in activeWorkouts {
//            if workout.template == template {
//                count += 1
//            }
//        }
//        return count
//    }
    
    
    @State private var presentProgress = false
    @State private var hasStartError = false
    @State private var activeWorkout: ActiveWorkout = ActiveWorkout()
    @State private var currentExercise: ActiveExercise = ActiveExercise()
    
    func updatePresentProgress () {
        for workout in activeWorkouts {
            if Calendar.current.isDateInToday(workout.date) && !workout.isComplete {
                // show an eror alert
                hasStartError = true
                return
            }
        }
        
        activeWorkout = ActiveWorkout(template: template)
        currentExercise = ActiveExercise(template: template.exercises[0])
        
        modelContext.insert(activeWorkout)
        modelContext.insert(currentExercise)
        
        activeWorkout.exercises.append(currentExercise)
        presentProgress = true
    }
    
    func finishWorkout () {
        activeWorkout.isComplete = true
        presentProgress = false
    }
    
    func goToNextExercise () {
        if(activeWorkout.template.exercises.count == activeWorkout.exercises.count) {
            finishWorkout()
            return
        }
        let nextExercise = activeWorkout.template.exercises[activeWorkout.exercises.count]
        currentExercise = ActiveExercise(template: nextExercise)
        
        modelContext.insert(currentExercise)
        activeWorkout.exercises.append(currentExercise)
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
                    Text("\(activeWorkouts.count)")
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
                Button("Start Workout", action: updatePresentProgress)
            }
        }
        .fullScreenCover(isPresented: $presentProgress) {
            ProgressView(activeWorkout: activeWorkout, currentExercise: currentExercise)
        }
        .alert("Error", isPresented: $hasStartError) {
            Button("OK") {}
        } message: {
            Text("There is already a workout in progress for today. Delete to start a new one")
        }
    }
}
