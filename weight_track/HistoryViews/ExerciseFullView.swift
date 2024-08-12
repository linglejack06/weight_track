//
//  ExerciseFullView.swift
//  weight_track
//
//  Created by Jack Lingle on 8/12/24.
//

import SwiftUI
import SwiftData

struct ExerciseFullView: View {
    let exercise: ActiveExercise
    let highestWeightSet: Set
    let highestRepSet: Set
    let completionTimes: Int
    
    init(exercise: ActiveExercise, exercises: [ActiveExercise]) {
        self.exercise = exercise
        let exerciseTemplateName = exercise.template.name
        
        var matchingExercises = exercises.filter({$0.template.name == exerciseTemplateName && $0.sets.count > 0 })
        matchingExercises.append(exercise)
        self.completionTimes = matchingExercises.count
        print(matchingExercises.count)
        var highestWeight = matchingExercises[0].sets[0]
        var highestRep = matchingExercises[0].sets[0]
        
        for ex in matchingExercises {
            for set in ex.sets {
                if set.weight > highestWeight.weight {
                    highestWeight = set
                }
                if set.reps > highestRep.reps {
                    highestRep = set
                }
            }
        }
        
        self.highestWeightSet = highestWeight
        self.highestRepSet = highestRep
    }
    var body: some View {
        List {
            Section {
                Text("Highest Weight: \(highestWeightSet.weight)\(highestWeightSet.unit) for \(highestWeightSet.reps) Reps")
                Text("Highest Reps: \(highestRepSet.weight)\(highestRepSet.unit) for \(highestRepSet.reps) Reps")
                Text("Completed \(completionTimes) Times")
            }
            Section ("This Workout's Sets") {
                ForEach(exercise.sets) { set in
                    SetRowView(set: set)
                }
            }
        }
        Text(exercise.template.name)
    }
}
