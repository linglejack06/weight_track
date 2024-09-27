//
//  ContentView.swift
//  weight_track
//
//  Created by Jack Lingle on 7/22/24.
//

import SwiftUI
import SwiftData
import UserNotifications

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var workouts: [WorkoutTemplate]
    @Query private var activeWorkouts: [ActiveWorkout]
    @State private var isPresented = false
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, _ in
            if success {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
            }
            .onAppear {
                requestNotificationPermission()
            }
        }
    }

#Preview {
    ContentView()
        .modelContainer(for: WorkoutTemplate.self)
}
