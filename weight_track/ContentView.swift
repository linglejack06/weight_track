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
    @State private var isPresented = false
    
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
            Text("home")
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
