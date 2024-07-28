//
//  ContentView.swift
//  weight_track
//
//  Created by Jack Lingle on 7/22/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var workouts: [WorkoutTemplate]
    
    func addSamples() {
        let push = WorkoutTemplate(title: "main chest", category: .push)
        modelContext.insert(push)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(workouts) { workout in
                    HStack {
                        Text(workout.title)
                        Text(workout.category.rawValue)
                    }
                }
            }
            .navigationTitle("Workout Templates")
            .toolbar {
                Button("Add Samples", action: addSamples)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: WorkoutTemplate.self)
}
