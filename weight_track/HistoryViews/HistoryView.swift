//
//  HistoryView.swift
//  weight_track
//
//  Created by Jack Lingle on 8/4/24.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var workouts: [ActiveWorkout]
    @State private var presentProgress = false
    
    var activeWorkout: ActiveWorkout? {
        get {
            for workout in workouts {
                if Calendar.current.isDateInToday(workout.date) && !workout.isComplete {
                    return workout
                }
            }
            return nil
        }
        set(newWorkout) {
            
        }
    }
    
    func deleteActiveWorkout () {
        modelContext.delete(activeWorkout!)
    }
    
    var body: some View {
        List {
            if (activeWorkout != nil) {
                Section("Incomplete Workout") {
                    VStack {
                        ActiveCardView(activeWorkout: activeWorkout!)
                        HStack {
                            Button("Delete", action: deleteActiveWorkout )
                                .buttonStyle(BorderlessButtonStyle())
                            Spacer()
                            Button("Continue", action: { presentProgress = true })
                                .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $presentProgress) {
            if (activeWorkout != nil) {
                ProgressView(activeWorkout: self.activeWorkout!, context: modelContext)
            }
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: ActiveWorkout.self)
}
