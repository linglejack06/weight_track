//
//  Exercise.swift
//  weight_track
//
//  Created by Jack Lingle on 7/28/24.
//

import Foundation
import SwiftData

enum WeightType: String, CaseIterable, Codable {
    case pounds = "lbs"
    case kilograms = "kg"
}

@Model
class Set {
    var weight: Double
    var reps: Int
    var unit: WeightType
    @Relationship(inverse: \ActiveExercise.sets) var exercise: ActiveExercise?
    
    init(weight: Double = 0.0, reps: Int = 0, unit: WeightType = .pounds, exercise: ActiveExercise? = nil) {
        self.weight = weight
        self.reps = reps
        self.unit = unit
        self.exercise = exercise
    }
}

@Model
class ExerciseTemplate {
    var numOfSets: Int
    var name: String
    var restBetweenSets: Double
    @Relationship(inverse: \WorkoutTemplate.exercises) var workoutTemplates: [WorkoutTemplate]
    
    init(numOfSets: Int = 0, name: String = "", restBetweenSets: Double = 0.0, workoutTemplates: [WorkoutTemplate] = []) {
        self.numOfSets = numOfSets
        self.name = name
        self.restBetweenSets = restBetweenSets
        self.workoutTemplates = workoutTemplates
    }
}

@Model
class ActiveExercise {
    @Relationship(deleteRule: .cascade) var sets: [Set]
    var template: ExerciseTemplate
    @Relationship(inverse: \ActiveWorkout.exercises) var workout: ActiveWorkout?
    var date: Date
    
    init(template: ExerciseTemplate = ExerciseTemplate(), sets: [Set] = [], workout: ActiveWorkout? = nil, date: Date = .now) {
        self.template = template
        self.sets = sets
        self.workout = workout
        self.date = date
    }
}
