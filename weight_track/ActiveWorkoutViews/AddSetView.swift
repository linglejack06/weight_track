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
    @Query private var previousWorkouts: [ActiveWorkout]
    @Binding var currentExercise: ActiveExercise
    var exerciseSets: Int
    var goToNextExercise: () -> Void
    
    init (template: WorkoutTemplate, currentExercise: Binding<ActiveExercise>, exerciseSets: Int, goToNextExercise: @escaping () -> Void) {
        let titleToCompare = template.title
        _previousWorkouts = Query()
        _currentExercise = currentExercise
        self.exerciseSets = exerciseSets
        self.goToNextExercise = goToNextExercise
    }
    
    func addSet () {
        currentExercise.sets.append(Set(weight: self.weight!, reps: self.reps!, unit: self.weightType))
        weight = nil
        reps = nil
        
        setNumber += 1
    }
    
    func deleteSet(_ indexSet: IndexSet) {
        currentExercise.sets.remove(atOffsets: indexSet)
    }
    
    func moveSet(from source: IndexSet, to destination: Int) {
        currentExercise.sets.move(fromOffsets: source, toOffset: destination)
    }
    
    func useSuggestion() {
        self.weightType = lastUnit
        self.weight = lastWeight
        self.reps = lastReps
        presentPopover = false
    }
    
    func findSetSuggestion() {
        if let previousWorkout: ActiveWorkout = previousWorkouts.sorted(by: { $0.date > $1.date }).first(where: { $0.isComplete }) {
            
            if let previousExercise: ActiveExercise = previousWorkout.exercises.first(where: { $0.template.name == currentExercise.template.name }) {
                var previousSet: Set?
                
                if (previousExercise.sets.count >= currentExercise.sets.count) {
                    previousSet = previousExercise.sets[currentExercise.sets.count > 0 ? currentExercise.sets.count - 1 : 0]
                } else {
                    previousSet = previousExercise.sets.last
                }
                
                if (previousSet != nil) {
                    lastWeight = previousSet!.weight
                    lastReps = previousSet!.reps
                    return
                }
            }
        } else {
            lastReps = 0
            lastWeight = 0.0
        }
    }
    
    func convertToUnit(_ unit: WeightType) {
        if unit == .kilograms && weight != nil {
            let measurement = Measurement(value: weight!, unit: UnitMass.pounds)
            let kgConversion = measurement.converted(to: UnitMass.kilograms)
            weight = kgConversion.value
        } else if unit == .pounds && weight != nil {
            let measurement = Measurement(value: weight!, unit: UnitMass.kilograms)
            let lbConversion = measurement.converted(to: UnitMass.pounds)
            weight = lbConversion.value
        }
        
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
            ForEach(currentExercise.sets.reversed()) { set in
                SetRowView(set: set)
            }
            .onDelete(perform: deleteSet)
            .onMove(perform: moveSet)
        }
        if(currentExercise.sets.count < exerciseSets) {
            HStack (alignment: .lastTextBaseline){
                VStack (alignment: .leading, spacing: 2) {
                    Text("Set \(currentExercise.sets.count + 1) of \(exerciseSets)")
                        .foregroundStyle(Color.secondary)
                        .font(.caption)
                    HStack {
                        TextField("Weight", value: $weight, format: .number)
                            .keyboardType(.decimalPad)
                            .onChange(of: lastWeight) { oldValue, newValue in
                                if newValue > 0 {
                                    presentPopover = true
                                } else {
                                    presentPopover = false
                                }
                            }
                            .onTapGesture(perform: {
                                findSetSuggestion()
                            })
                            .popover(isPresented: $presentPopover, arrowEdge: .bottom) {
                                Button { useSuggestion() } label: {
                                    VStack(alignment: .leading) {
                                        Text("Last Time")
                                            .font(.headline)
                                        Divider()
                                        HStack {
                                            Image(systemName: "dumbbell")
                                            Text(String(format: "%.2f", lastWeight) + " \(lastUnit.rawValue)")
                                            Text("\(lastReps) Reps")
                                        }
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .foregroundStyle(Color.secondary)
                                }
                                .padding(4)
                                .presentationCompactAdaptation(.popover)
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
        }
    }
}
