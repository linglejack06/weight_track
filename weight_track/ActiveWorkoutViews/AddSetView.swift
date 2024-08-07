//
//  AddSetView.swift
//  weight_track
//
//  Created by Jack Lingle on 8/6/24.
//

import SwiftUI
import SwiftData

struct AddSetView: View {
    @State private var weight: Float? = nil
    @State private var weightType: WeightType = .pounds
    @State private var reps: Int? = nil
    @State private var presentPopover = false
    @State private var lastWeight: Float = 0.0
    @State private var lastReps: Int = 0
    @State private var lastUnit: WeightType = .pounds
    @State private var setNumber = 1
    @Query private var previousWorkouts: [ActiveWorkout]
    @Binding var currentExercise: ActiveExercise
    var exerciseSets: Int
    var goToNextExercise: () -> Void
    
    init (template: WorkoutTemplate, currentExercise: Binding<ActiveExercise>, exerciseSets: Int, goToNextExercise: @escaping () -> Void) {
        let titleToCompare = template.title
        let filter = #Predicate<ActiveWorkout> {
            $0.template.title == titleToCompare
        }
        _previousWorkouts = Query(filter: filter)
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
                    presentPopover = true
                    return
                }
            }
        }
        lastReps = 0
        lastWeight = 0.0
        presentPopover = false
    }
    
    var body: some View {
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
                            .onChange(of: weight){ oldValue, newValue in
                                findSetSuggestion()
                            }
                            .popover(isPresented: $presentPopover, arrowEdge: .bottom) {
                                Button { useSuggestion() } label: {
                                    VStack(alignment: .leading) {
                                        Text("Last Time")
                                        HStack {
                                            Text("\(lastWeight) \(lastUnit.rawValue)")
                                            Text("\(lastReps) Reps")
                                        }
                                    }
                                }
                                .padding(4)
                                .presentationCompactAdaptation(.popover)
                            }
                        Picker("", selection: $weightType) {
                            ForEach(WeightType.allCases, id: \.self) { type in
                                Text(type.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
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
