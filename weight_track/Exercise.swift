//
//  Exercise.swift
//  weight_track
//
//  Created by Jack Lingle on 7/28/24.
//

import Foundation
import SwiftData

@Model
class ExerciseTemplate {
    var numOfSets: Int
    var name: String
    var workout: WorkoutTemplate?
    
    init(numOfSets: Int = 0, name: String = "", workout: WorkoutTemplate? = nil) {
        self.numOfSets = numOfSets
        self.name = name
        self.workout = workout
    }
}

@Model
class ActiveExercise {
    var weight: [Float]
    var reps: [Int]
    var template: ExerciseTemplate
    var workout: ActiveWorkout?
    var date: Date
    
    init(template: ExerciseTemplate = ExerciseTemplate(), weight: [Float] = [], reps: [Int] = [], workout: ActiveWorkout? = nil, date: Date = .now) {
        self.template = template
        self.weight = weight
        self.reps = reps
        self.workout = workout
        self.date = date
    }
}
