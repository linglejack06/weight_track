//
//  AddSetView.swift
//  weight_track
//
//  Created by Jack Lingle on 8/6/24.
//

import SwiftUI

struct AddSetView: View {
    @State private var weight: Float = 0.0
    @State private var weightType: WeightType = .pounds
    @State private var reps: Int = 0
    @Binding var sets: [Set]
    let exerciseSets: Int
    let goToNextExercise: () -> Void
    
    func addSet () {
        sets.append(Set(weight: self.weight, reps: self.reps, unit: self.weightType))
        weight = 0.0
        reps = 0
        
        if (exerciseSets == sets.count) {
            goToNextExercise()
        }
    }
    
    func deleteSet(_ indexSet: IndexSet) {
        sets.remove(atOffsets: indexSet)
    }
    
    func moveSet(from source: IndexSet, to destination: Int) {
        sets.move(fromOffsets: source, toOffset: destination)
    }
    var body: some View {
        List {
            ForEach($sets) { $set in
                
            }
            .onDelete(perform: deleteSet)
            .onMove(perform: moveSet)
        }
        HStack {
            Text("Set \(sets.count + 1) of \(exerciseSets)")
            TextField("Weight", value: $weight, format: .number)
                .keyboardType(.decimalPad)
            Picker("", selection: $weightType) {
                ForEach(WeightType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            }
            TextField("Reps", value: $reps, format: .number)
                .keyboardType(.numberPad)
            Button("Add Set", action: addSet)
        }
    }
}
