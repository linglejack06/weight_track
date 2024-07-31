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
    @State private var isPresented = false
    
    func deleteTemplate(_ indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(workouts[index])
        }
    }
    
    init(sortedCategory: WorkoutCategory? = nil) {
        var filter: Predicate<WorkoutTemplate>
        if (sortedCategory != nil) {
            filter = #Predicate<WorkoutTemplate> { workout in
                return workout.category == sortedCategory!
            }
        } else {
            filter = #Predicate<WorkoutTemplate> { workout in
                return true
            }
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
            .navigationTitle("Workout Templates")
            .toolbar {
                ToolbarItem {
                    Button("Add Workout", action: {isPresented = true})
                }
            }
            .sheet(isPresented: $isPresented) {
                NavigationStack {
                    AddTemplateView()
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Cancel", action: { isPresented.toggle() })
                            }
                        }
                        .navigationTitle("New Workout Template")
                }
            }
        }
    }
}

#Preview {
    TemplateListView()
        .modelContainer(for: WorkoutTemplate.self)
}
