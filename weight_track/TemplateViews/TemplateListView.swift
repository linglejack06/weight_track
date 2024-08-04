//
//  TemplateListView.swift
//  weight_track
//
//  Created by Jack Lingle on 7/29/24.
//

import SwiftUI
import SwiftData

struct TemplateListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var workouts: [WorkoutTemplate]
    
    func deleteTemplate(_ indexSet: IndexSet) {
        for index in indexSet {
            // delete exercises with only this template as parent
            for exercise in workouts[index].exercises {
                if exercise.workoutTemplates.count == 1 {
                    modelContext.delete(exercise)
                }
            }
            modelContext.delete(workouts[index])
        }
    }
    
    init(sortedCategory: WorkoutCategoryWithAll = .all) {
        var filter: Predicate<WorkoutTemplate>
        if (sortedCategory != .all) {
            let categoryToCompare = sortedCategory.rawValue
            filter = #Predicate<WorkoutTemplate> {
                $0.category == categoryToCompare
            }
        } else {
            filter = #Predicate<WorkoutTemplate> { _ in return true }
        }
        _workouts = Query(filter: filter)
    }

    var body: some View {
        if (workouts.count > 0) {
            ForEach(workouts) { workout in
                TemplateCardView(template: workout)
                Text("\(workout.exercises.count)")
            }
            .onDelete(perform: deleteTemplate)
        } else {
            Text("Oops! No workouts match this category.")
        }
    }
}

#Preview {
    TemplateListView()
        .modelContainer(for: WorkoutTemplate.self)
}
