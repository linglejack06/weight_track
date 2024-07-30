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
    var body: some View {
        List {
            ForEach(workouts) { workout in
                Text(workout.title)
            }
            .onDelete(perform: deleteTemplate)
        }
        .navigationTitle("Workout Templates")
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

#Preview {
    TemplateListView()
        .modelContainer(for: WorkoutTemplate.self)
}
