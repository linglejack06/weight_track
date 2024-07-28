//
//  weight_trackApp.swift
//  weight_track
//
//  Created by Jack Lingle on 7/22/24.
//

import SwiftUI
import SwiftData

@main
struct weight_trackApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            WorkoutTemplate.self,
            ActiveWorkout.self,
            ExerciseTemplate.self,
            ActiveExercise.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
