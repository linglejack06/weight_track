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
        
        currentExercise.workout = activeWorkout
    }
    
    init(activeWorkout: ActiveWorkout, context: ModelContext) {
        self.activeWorkout = activeWorkout
        // fast forward to first exercise not completed
        let possibleExercise = activeWorkout.exercises.last
        if(possibleExercise != nil && (possibleExercise!.sets.count) != possibleExercise!.template.numOfSets) {
            currentExercise = possibleExercise!
        } else {
            let nextExercise = activeWorkout.template.exercises[activeWorkout.exercises.count]
            currentExercise = ActiveExercise(template: nextExercise)
            context.insert(currentExercise)
            currentExercise.workout = self.activeWorkout
        }
    }
    
    func goToNextExercise () {
        if(activeWorkout.template.exercises.count == activeWorkout.exercises.count) {
            finishWorkout()
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
    
    func finishWorkout () {
        activeWorkout.isComplete = true
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
                    AddSetView(template: activeWorkout.template, currentExercise: $currentExercise, exerciseSets: currentExercise.template.numOfSets, goToNextExercise: goToNextExercise)
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
                        Button("Finish", action: finishWorkout)
                    } else {
                        Button("Move On", action: goToNextExercise)
                    }
                }
            }
        }
    }
}

