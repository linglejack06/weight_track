//
//  Workout.swift
//  weight_track
//
//  Created by Jack Lingle on 7/28/24.
//

import Foundation
import SwiftData

enum WorkoutCategory {
    case push, pull, legs, upper, core
}

@Model
class WorkoutTemplate {
    var title: String
    @Relationship(deleteRule: .cascade) var exercises = [ExerciseTemplate]()
    var category: WorkoutCategory
    
    init(title: String = "", exercises: [ExerciseTemplate] = [], category: WorkoutCategory = .push) {
        self.title = title
        self.exercises = exercises
        self.category = category
    }
}

@Model
class ActiveWorkout {
    var date: Date
    @Relationship(deleteRule: .cascade) var exercises = [ActiveExercise]()
    var template: WorkoutTemplate
    
    init(template: WorkoutTemplate = WorkoutTemplate(), date: Date = .now) {
        self.template = template
        self.date = date
        self.exercises = template.exercises.map { ActiveExercise(template: $0) }
    }
}
