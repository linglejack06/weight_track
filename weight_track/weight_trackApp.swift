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
        let modelConfiguration = ModelConfiguration()

        do {
            return try ModelContainer(for: WorkoutTemplate.self, ActiveWorkout.self, configurations: modelConfiguration)
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
