//
//  SetFormView.swift
//  weight_track
//
//  Created by Jack Lingle on 8/8/24.
//

import SwiftUI
import SwiftData

struct SetFormView: View {
    @Query private var previousWorkouts: [ActiveWorkout]
    @State private var weightType: WeightType = .pounds
    @State private var weight: Double = 0.0
    @State private var reps: Int = 0
    @State private var presentPopover = false
    @State private var previousSets: [Set] = []
    @Binding var currentExercise: ActiveExercise
    let exerciseSets: Int
    let goToNextExercise: () -> Void
    
    func addSet () {
        currentExercise.sets.append(Set(weight: self.weight, reps: self.reps, unit: self.weightType))
        weight = 0.0
        reps = 0
        
        if(currentExercise.sets.count == exerciseSets) {
            goToNextExercise()
        }
        
        presentPopover = false
    }
    
    func useSuggestion(previousSet: Set) {
        self.weightType = previousSet.unit
        self.weight = previousSet.weight
        self.reps = previousSet.reps
        presentPopover = false
    }
    
    func findSetSuggestion() {
        if let previousWorkout: ActiveWorkout = previousWorkouts.sorted(by: { $0.date > $1.date }).first(where: { $0.isComplete }) {
            
            if let previousExercise: ActiveExercise = previousWorkout.exercises.first(where: { $0.template.name == currentExercise.template.name }) {
                self.previousSets = previousExercise.sets
            }
        } else {
            self.previousSets = []
        }
    }
    var body: some View {
        HStack (alignment: .lastTextBaseline){
            VStack (alignment: .leading, spacing: 2) {
                HStack {
                    Text("Set \(currentExercise.sets.count + 1) of \(exerciseSets)")
                        .foregroundStyle(Color.secondary)
                        .font(.caption)
                    Spacer()
                    if previousSets.count > 0 {
                        Button("Last Time's Sets", action: { presentPopover = true })
                            .font(.caption)
                            .popover(isPresented: $presentPopover, arrowEdge: .bottom) {
                                PreviousSetListView(previousSets: previousSets, useSuggestion: useSuggestion)
                            }
                    }
                }
                HStack {
                    TextField("Weight", value: $weight, format: .number)
                        .keyboardType(.decimalPad)
                    TextField("Reps", value: $reps, format: .number)
                        .keyboardType(.numberPad)
                }
                HStack {
                    Spacer()
                    Button("Add Set", action: addSet)
                        .disabled(reps == 0)
                    Spacer()
                }
            }
        }
        .onAppear(perform: {
            findSetSuggestion()
        })
    }
}

