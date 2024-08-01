//
//  Workout.swift
//  weight_track
//
//  Created by Jack Lingle on 7/28/24.
//

import Foundation
import SwiftData

enum WorkoutCategory: String, CaseIterable, Codable {
    case push = "Push"
    case pull = "Pull"
    case legs = "Legs"
    case upper = "Upper Body"
    case core = "Core"
}

enum WorkoutCategoryWithAll: String, CaseIterable, Codable {
    case push = "Push"
    case pull = "Pull"
    case legs = "Legs"
    case upper = "Upper Body"
    case core = "Core"
    case all = "All"
}

@Model
class WorkoutTemplate {
    var title: String
    var exercises: [ExerciseTemplate]
    var category: String = WorkoutCategory.push.rawValue
    
    init(title: String = "", exercises: [ExerciseTemplate] = [], category: WorkoutCategory = .push) {
        self.title = title
        self.exercises = exercises
        self.category = category.rawValue
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

let sampleWorkoutTemplate = WorkoutTemplate(title: "Full Upper", exercises: [ExerciseTemplate(numOfSets: 8, name: "chest press", workoutTemplates: [])],category: .upper )
