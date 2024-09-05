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
    @State var activeWorkout: ActiveWorkout
    @State var currentExercise: ActiveExercise
    var refreshPage = { }
    
    func cancelWorkout () {
        modelContext.delete(activeWorkout)
        refreshPage()
        dismiss()
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
    
    func finishWorkout () {
        activeWorkout.isComplete = true
        refreshPage()
        dismiss()
    }
    
    func addSetToExercise (_ set: Set) {
        currentExercise.sets.append(set)
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
                AddSetView(currentExercise: $currentExercise, exerciseSets: currentExercise.template.numOfSets, goToNextExercise: goToNextExercise, addSetToExercise: addSetToExercise)
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

