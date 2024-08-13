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

    var body: some View {
        Section(exercise.template.name) {
            ForEach(exercise.sets) { set in
                SetRowView(set: set)
            }
        }
    }
}
