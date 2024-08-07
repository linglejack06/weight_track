//
//  ActiveWorkoutListView.swift
//  weight_track
//
//  Created by Jack Lingle on 8/5/24.
//

import SwiftUI
import SwiftData

struct ActiveWorkoutListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var activeWorkouts: [ActiveWorkout]
    
    init(sortedCategory: WorkoutCategoryWithAll = .all, searchBy: String = "") {
        var filter: Predicate<ActiveWorkout>
        if (sortedCategory != .all) {
            let categoryToCompare = sortedCategory.rawValue
            filter = #Predicate<ActiveWorkout> {
                if $0.template.category == categoryToCompare {
                    if searchBy == "" || $0.template.title.localizedStandardContains(searchBy) {
                        return true
                    } else {
                        return false
                    }
                } else {
                    return false
                }
            }
        } else {
            filter = #Predicate<ActiveWorkout> { searchBy == "" || $0.template.title.localizedStandardContains(searchBy)
            }
        }
        _activeWorkouts = Query(filter: filter, sort: \ActiveWorkout.date, order: .reverse)
    }
    
    var body: some View {
        ForEach(activeWorkouts) { workout in
            if(workout.isComplete) {
                NavigationLink {
                    ActiveFullView()
                } label: {
                    ActiveCardView(activeWorkout: workout)
                }
            }
        }
    }
}

