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
    @Query private var activeWorkouts: [ActiveWorkout]
    @State private var isPresented = false
    var activeWorkout: ActiveWorkout? {
        get {
            for workout in activeWorkouts {
                if Calendar.current.isDateInToday(workout.date) && !workout.isComplete {
                    return workout
                }
            }
            return nil
        }
        set(newWorkout) {
            
        }
    }
    
    func addSamples() {
        let push = WorkoutTemplate(title: "main chest", category: .push)
        modelContext.insert(push)
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            HistoryView(activeWorkout: activeWorkout)
                .tabItem {
                    Label("History", systemImage: "clock")
                }
            }
        }
    }

#Preview {
    ContentView()
        .modelContainer(for: WorkoutTemplate.self)
}
