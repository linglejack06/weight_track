//
//  TemplateListView.swift
//  weight_track
//
//  Created by Jack Lingle on 7/29/24.
//

import SwiftUI
import SwiftData

struct TemplateListView: View {
    @Query private var workouts: [WorkoutTemplate]
    var body: some View {
        List {
            ForEach(workouts) { workout in
                Text(workout.title)
            }
        }
    }
}

#Preview {
    TemplateListView()
        .modelContainer(for: WorkoutTemplate.self)
}
