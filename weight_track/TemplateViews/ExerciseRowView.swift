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
            Text("\(exercise.numOfSets) Sets")
            Spacer()
            if(Int(exercise.restBetweenSets / 60) > 0) {
                if(Int(exercise.restBetweenSets.truncatingRemainder(dividingBy: 60)) > 0) {
                    Text("Rest: \(Int(exercise.restBetweenSets / 60))m \(Int(exercise.restBetweenSets.truncatingRemainder(dividingBy: 60)))s")
                } else {
                    Text("Rest: \(Int(exercise.restBetweenSets / 60))m")
                }
            } else if (Int(exercise.restBetweenSets.truncatingRemainder(dividingBy: 60)) > 0) {
                Text("Rest: \(Int(exercise.restBetweenSets.truncatingRemainder(dividingBy: 60)))s")
            } else {
                Text("Rest: none")
            }
        }
    }
}

#Preview {
    ExerciseRowView(exercise: sampleExerciseTemplate)
}
