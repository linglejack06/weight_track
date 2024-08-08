//
//  AddSetView.swift
//  weight_track
//
//  Created by Jack Lingle on 8/6/24.
//

import SwiftUI
import SwiftData

struct AddSetView: View {
    @State private var weight: Double? = nil
    @State private var weightType: WeightType = .pounds
    @State private var reps: Int? = nil
    @State private var presentPopover = false
    @State private var lastWeight: Double = 0.0
    @State private var lastReps: Int = 0
    @State private var lastUnit: WeightType = .pounds
    @State private var setNumber = 1
    @State private var previousSets: [Set] = []
    @Query private var previousWorkouts: [ActiveWorkout]
    @Binding var currentExercise: ActiveExercise
    var exerciseSets: Int
    var goToNextExercise: () -> Void
    
    func deleteSet(_ indexSet: IndexSet) {
        currentExercise.sets.remove(atOffsets: indexSet)
    }
    
    func moveSet(from source: IndexSet, to destination: Int) {
        currentExercise.sets.move(fromOffsets: source, toOffset: destination)
    }
    
    func convertToUnit(_ unit: WeightType) {
        // update current weight
        if unit == .kilograms && weight != nil {
            let measurement = Measurement(value: weight!, unit: UnitMass.pounds)
            let kgConversion = measurement.converted(to: UnitMass.kilograms)
            weight = kgConversion.value
        } else if unit == .pounds && weight != nil {
            let measurement = Measurement(value: weight!, unit: UnitMass.kilograms)
            let lbConversion = measurement.converted(to: UnitMass.pounds)
            weight = lbConversion.value
        }
        
        // update past set weights
        for set in currentExercise.sets {
            if unit == .kilograms {
                let measurement = Measurement(value: set.weight, unit: UnitMass.pounds)
                let kgConversion = measurement.converted(to: UnitMass.kilograms)
                set.weight = kgConversion.value
                set.unit = .kilograms
            } else if unit == .pounds {
                let measurement = Measurement(value: set.weight, unit: UnitMass.kilograms)
                let lbConversion = measurement.converted(to: UnitMass.pounds)
                set.weight = lbConversion.value
                set.unit = .pounds
            }
        }
    }
    
    var body: some View {
        Section ("Sets") {
            Picker("", selection: $weightType) {
                ForEach(WeightType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
                .onChange(of: weightType) { oldValue, newValue in
                    convertToUnit(newValue)
                }
            }
            .pickerStyle(.segmented)
            List {
                ForEach(currentExercise.sets) { set in
                    SetRowView(set: set)
                }
                .onDelete(perform: deleteSet)
                .onMove(perform: moveSet)
            }
            if(currentExercise.sets.count < exerciseSets) {
                SetFormView(currentExercise: $currentExercise, exerciseSets: exerciseSets)
            }
        }
    }
}
