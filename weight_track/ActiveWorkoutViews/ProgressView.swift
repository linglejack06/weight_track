//
//  ProgressView.swift
//  weight_track
//
//  Created by Jack Lingle on 8/2/24.
//

import SwiftUI
import SwiftData

struct ProgressView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var activeWorkout: ActiveWorkout
    
    init (template: WorkoutTemplate = WorkoutTemplate(), context: ModelContext) {
        activeWorkout = ActiveWorkout(template: template)
        context.insert(activeWorkout)
    }
    
    func cancelWorkout () {
        modelContext.delete(activeWorkout)
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Text(activeWorkout.template.title)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", action: cancelWorkout)
                }
                ToolbarItem(placement: .principal) {
                    Text(activeWorkout.template.title)
                }
                ToolbarItem {
                    Button("Save", action: { dismiss() })
                }
            }
        }
    }
}

