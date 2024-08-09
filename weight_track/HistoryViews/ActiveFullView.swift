//
//  ActiveFullView.swift
//  weight_track
//
//  Created by Jack Lingle on 8/6/24.
//

import SwiftUI

struct ActiveFullView: View {
    let workout: ActiveWorkout
    var body: some View {
        List {
            Section {
                Text("Completed on \(workout.date.formatted(.dateTime.day().month().year()))")
            }
            // add list of exercises with dropdown for set list
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(workout.template.title)
                    Text("Category: \(workout.template.category)")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondary)
                }
            }
        }
    }
}

