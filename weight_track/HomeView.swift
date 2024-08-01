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
                Picker("Sort By", selection: $sortedCategory) {
                    ForEach(WorkoutCategoryWithAll.allCases, id: \.self) { category in
                        Text("\(category.rawValue)")
                    }
                }
                TemplateListView(sortedCategory: sortedCategory)
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
    HomeView()
}
