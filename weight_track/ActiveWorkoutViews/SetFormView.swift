//
//  SetFormView.swift
//  weight_track
//
//  Created by Jack Lingle on 8/8/24.
//

import SwiftUI
import SwiftData

struct SetFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var previousWorkouts: [ActiveWorkout]
    @State private var weight: Double? = nil
    @State private var reps: Int? = nil
    @State private var presentPopover = false
    @State private var previousSets: [Set] = []
    @State private var isRepsNil: Bool = true
    @State private var isWeightNil: Bool = true
    @Binding var currentExercise: ActiveExercise
    let exerciseSets: Int
    let goToNextExercise: () -> Void
    let addSetToExercise: (Set) -> Void
    @Binding var weightType: WeightType
    
    func addSet () {
        let newSet = Set(weight: self.weight ?? 0, reps: self.reps!, unit: self.weightType, exercise: currentExercise)
        modelContext.insert(newSet)
        addSetToExercise(newSet)
        weight = nil
        reps = nil
        
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
                Spacer()
                HStack {
                    LabelledTextInput(title: "Weight", isNil: $isWeightNil) {
                        TextField("", value: $weight, format: .number)
                            .keyboardType(.decimalPad)
                            .onChange(of: weight) { oldValue, newValue in
                                isWeightNil = newValue == nil
                            }
                    }
                    LabelledTextInput(title: "Reps", isNil: $isRepsNil) {
                        TextField("Reps", value: $reps, format: .number)
                            .keyboardType(.numberPad)
                            .onChange(of: reps) { oldValue, newValue in
                                isRepsNil = newValue == nil
                            }
                    }
                    Button("Add Set", action: addSet)
                        .buttonStyle(BorderedProminentButtonStyle())
                        .disabled(reps == 0 || reps == nil)
                }
                Spacer()
                Spacer()
            }
        }
        .onAppear(perform: {
            findSetSuggestion()
        })
    }
}

