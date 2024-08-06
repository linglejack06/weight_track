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
                $0.template.category == categoryToCompare && $0.template.title.localizedStandardContains(searchBy)
            }
        } else {
            filter = #Predicate<ActiveWorkout> { $0.template.title.localizedStandardContains(searchBy)
            }
        }
        _activeWorkouts = Query(filter: filter, sort: \ActiveWorkout.date)
    }
    
    var body: some View {
        ForEach(activeWorkouts) { workout in
            NavigationLink {
                ActiveFullView()
            } label: {
                ActiveCardView(activeWorkout: workout)
            }
        }
    }
}

