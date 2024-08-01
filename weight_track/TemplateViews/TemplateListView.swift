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
        NavigationStack {
            List {
                ForEach(workouts) { workout in
                    TemplateCardView(template: workout)
                }
                .onDelete(perform: deleteTemplate)
            }
        }
    }
}

#Preview {
    TemplateListView()
        .modelContainer(for: WorkoutTemplate.self)
}
