//
//  AddTemplateView.swift
//  weight_track
//
//  Created by Jack Lingle on 7/29/24.
//

import SwiftUI
import SwiftData

struct AddTemplateView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var workouts: [WorkoutTemplate]
    @State private var title = ""
    @State private var category: WorkoutCategory = .push
    @State private var exerciseName = ""
    @State private var numOfSets = 0
    @State private var exercises: [ExerciseTemplate] = []
    
    func addExercise () {
        let exerciseToAdd = ExerciseTemplate(numOfSets: numOfSets, name: exerciseName)

        withAnimation {
            exercises.append(exerciseToAdd)
        }
        exerciseName = ""
        numOfSets = 0
    }
    
    func deleteExercise (_ indexSet: IndexSet) {
        exercises.remove(atOffsets: indexSet)
    }
    
    func addWorkout () {
        let workoutToAdd = WorkoutTemplate(title: title, exercises: exercises, category: category)
        if workouts.contains(workoutToAdd) {
//          display error that this workout already exists
        } else {
            modelContext.insert(workoutToAdd)
            dismiss()
        }
    }
    
    
    var body: some View {
        Form {
            TextField("Title", text: $title)
            Picker("Choose Type of Workout", selection: $category) {
                ForEach(WorkoutCategory.allCases, id: \.self) { cat in
                    Text("\(cat.rawValue)")
                }
            }
            Section("Exercises") {
                List {
                    ForEach(exercises) { exercise in
                        Text(exercise.name)
                    }
                    .onDelete(perform: deleteExercise)
                }
                HStack {
                    TextField("Name", text: $exerciseName)
                    TextField("Sets", value: $numOfSets, format: .number)
                    Button(action: addExercise) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .toolbar {
            Button(action: addWorkout) {
                Image(systemName: "plus")
            }
        }
    }
}

#Preview {
    AddTemplateView()
}
