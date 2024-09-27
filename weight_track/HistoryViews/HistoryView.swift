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
    @State private var sortedCategory: WorkoutCategoryWithAll = .all
    @State private var searchBy = ""
    
    @State var activeWorkout: ActiveWorkout? = nil
    
    func checkForWorkout () {
        for workout in workouts {
            if !workout.isComplete {
                activeWorkout = workout
            }
        }
    }
    
    func deleteActiveWorkout () {
        modelContext.delete(activeWorkout!)
        activeWorkout = nil
    }
    
    var body: some View {
        NavigationStack {
            List {
                if (activeWorkout != nil) {
                    Section("Incomplete Workout") {
                        VStack {
                            ActiveCardView(activeWorkout: activeWorkout!)
                            Divider()
                            HStack {
                                Button(role: .destructive, action: deleteActiveWorkout) {
                                    Text("Delete")
                                }
                                    .buttonStyle(BorderlessButtonStyle())
                                Spacer()
                                Button("Continue", action: {
                                    presentProgress = true
                                })
                                    .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }
                }
                Section("Completed Workouts") {
                    HStack (alignment: .center, spacing: 0) {
                        Picker("Category", selection: $sortedCategory) {
                            ForEach(WorkoutCategoryWithAll.allCases, id: \.self) { category in
                                Text("\(category.rawValue)")
                            }
                        }
                    }
                }
                Section {
                    ActiveWorkoutListView(sortedCategory: self.sortedCategory, searchBy: self.searchBy)
                }
            }
            .fullScreenCover(isPresented: $presentProgress) {
                if let unwrappedWorkout = activeWorkout {
                    ProgressView(activeWorkout: unwrappedWorkout, currentExercise: unwrappedWorkout.exercises.last!, refreshPage: { activeWorkout = nil })
                }
            }
            .searchable(text: $searchBy)
            .onAppear(perform: {
                checkForWorkout()
            })
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: ActiveWorkout.self)
}
