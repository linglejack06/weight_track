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
    
    init(numOfSets: Int = 0, name: String = "") {
        self.numOfSets = numOfSets
        self.name = name
    }
}

@Model
class ActiveExercise {
    var weight: [Float]
    var reps: [Int]
    var template: ExerciseTemplate
    
    init(template: ExerciseTemplate = ExerciseTemplate(), weight: [Float] = [], reps: [Int] = []) {
        self.template = template
        self.weight = weight
        self.reps = reps
    }
}
