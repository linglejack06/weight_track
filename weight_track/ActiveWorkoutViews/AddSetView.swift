//
//  AddSetView.swift
//  weight_track
//
//  Created by Jack Lingle on 8/6/24.
//

import SwiftUI

struct AddSetView: View {
    @State private var weight: Float? = nil
    @State private var weightType: WeightType = .pounds
    @State private var reps: Int? = nil
    @Binding var currentExercise: ActiveExercise
    let exerciseSets: Int
    let goToNextExercise: () -> Void
    
    func addSet () {
        currentExercise.sets.append(Set(weight: self.weight!, reps: self.reps!, unit: self.weightType))
        weight = nil
        reps = nil
        
        if (exerciseSets == currentExercise.sets.count) {
            goToNextExercise()
        }
    }
    
    func deleteSet(_ indexSet: IndexSet) {
        currentExercise.sets.remove(atOffsets: indexSet)
    }
    
    func moveSet(from source: IndexSet, to destination: Int) {
        currentExercise.sets.move(fromOffsets: source, toOffset: destination)
    }
    var body: some View {
        List {
            ForEach(currentExercise.sets.reversed()) { set in
                HStack {
                    Text("\(set.weight)")
                    Text("\(set.reps)")
                }
            }
            .onDelete(perform: deleteSet)
            .onMove(perform: moveSet)
        }
        HStack (alignment: .lastTextBaseline){
            VStack (alignment: .leading, spacing: 2) {
                Text("Set \(currentExercise.sets.count + 1) of \(exerciseSets)")
                    .foregroundStyle(Color.secondary)
                    .font(.caption)
                HStack {
                    TextField("Weight", value: $weight, format: .number)
                        .keyboardType(.decimalPad)
                    Picker("", selection: $weightType) {
                        ForEach(WeightType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            TextField("Reps", value: $reps, format: .number)
                .keyboardType(.numberPad)
        }
        HStack {
            Spacer()
            Button("Add Set", action: addSet)
                .disabled(weight == nil || reps == nil || reps == 0)
            Spacer()
        }
    }
}
