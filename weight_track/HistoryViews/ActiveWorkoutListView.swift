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
    
    init(sortedCategory: WorkoutCategoryWithAll = .all) {
        var filter: Predicate<ActiveWorkout>
        if (sortedCategory != .all) {
            let categoryToCompare = sortedCategory.rawValue
            filter = #Predicate<ActiveWorkout> {
                $0.template.category == categoryToCompare
            }
        } else {
            filter = #Predicate<ActiveWorkout> { _ in return true }
        }
        _activeWorkouts = Query(filter: filter)
    }
    
    var body: some View {
        ForEach(activeWorkouts) { workout in
            
        }
    }
}

#Preview {
    ActiveWorkoutListView()
}
