//
//  ExerciseRowView.swift
//  weight_track
//
//  Created by Jack Lingle on 8/2/24.
//

import SwiftUI

struct ExerciseRowView: View {
    let exercise: ExerciseTemplate
    var body: some View {
        HStack {
            Text(exercise.name)
            Spacer()
            Spacer()
            Text("\(exercise.numOfSets) Sets")
            Spacer()
        }
    }
}

#Preview {
    ExerciseRowView(exercise: sampleExerciseTemplate)
}
