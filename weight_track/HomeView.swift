//
//  HomeView.swift
//  weight_track
//
//  Created by Jack Lingle on 8/1/24.
//

import SwiftUI

struct HomeView: View {
    @State private var isPresented = false
    @State private var sortedCategory: WorkoutCategoryWithAll = .all
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        HStack (alignment: .center, spacing: 0) {
                            Picker("Category", selection: $sortedCategory) {
                                ForEach(WorkoutCategoryWithAll.allCases, id: \.self) { category in
                                    Text("\(category.rawValue)")
                                }
                            }
                        }
                    }
                    Section("Workouts") {
                        TemplateListView(sortedCategory: sortedCategory)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Text("Workout Templates")
                        .font(.title2)
                }
                ToolbarItem {
                    Button("Add Workout", action: {isPresented = true})
                        .font(.title2)
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
                        .navigationTitle("New Template")
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: WorkoutTemplate.self)
}
