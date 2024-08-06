//
//  ProgressView.swift
//  weight_track
//
//  Created by Jack Lingle on 8/2/24.
//

import SwiftUI
import SwiftData

struct ProgressView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var activeWorkout: ActiveWorkout
    @State private var currentExercise: ActiveExercise
    
    init (template: WorkoutTemplate = WorkoutTemplate(), context: ModelContext) {
        activeWorkout = ActiveWorkout(template: template)
        currentExercise = ActiveExercise(template: template.exercises[0])
        
        context.insert(activeWorkout)
        context.insert(currentExercise)
    }
    
    init(activeWorkout: ActiveWorkout, context: ModelContext) {
        self.activeWorkout = activeWorkout
        // fast forward to first exercise not completed
        let possibleExercise = activeWorkout.exercises.last
        if(possibleExercise != nil && possibleExercise!.sets.count != possibleExercise!.template.numOfSets) {
            currentExercise = possibleExercise!
        } else {
            let nextExercise = activeWorkout.template.exercises[activeWorkout.exercises.count]
            currentExercise = ActiveExercise(template: nextExercise)
            context.insert(currentExercise)
            self.activeWorkout.exercises.append(currentExercise)
        }
    }
    
    func goToNextExercise () {
        if(activeWorkout.template.exercises.count == activeWorkout.exercises.count) {
            return
        }
        let nextExercise = activeWorkout.template.exercises[activeWorkout.exercises.count]
        currentExercise = ActiveExercise(template: nextExercise)
        
        modelContext.insert(currentExercise)
        self.activeWorkout.exercises.append(currentExercise)
    }
    
    func cancelWorkout () {
        modelContext.delete(activeWorkout)
        dismiss()
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Text(currentExercise.template.name)
                        .font(.headline)
                    Spacer()
                    Text("\(currentExercise.template.numOfSets) Sets")
                        .font(.headline)
                }
                Section("Sets") {
                    AddSetView(currentExercise: $currentExercise, exerciseSets: currentExercise.template.numOfSets, goToNextExercise: goToNextExercise)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", action: { dismiss() })
                }
                ToolbarItem(placement: .principal) {
                    Text(activeWorkout.template.title)
                }
                ToolbarItem {
                    if(activeWorkout.template.exercises.count == activeWorkout.exercises.count) {
                        Button("Finish", action: {})
                    } else {
                        Button("Move On", action: goToNextExercise)
                    }
                }
            }
        }
    }
}

