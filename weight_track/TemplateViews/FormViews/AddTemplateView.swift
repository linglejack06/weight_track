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
    @Query private var existingExercises: [ExerciseTemplate]
    @State private var title = ""
    @State private var category: WorkoutCategory = .push
    @State private var exerciseName = ""
    @State private var numOfSets: Int? = nil
    @State private var exercises: [ExerciseTemplate] = []
    @State private var hasError = false
    @State private var exerciseSuggestions = [ExerciseTemplate]()
    @State private var presentPopover = false
    
    func deleteExercise (_ indexSet: IndexSet) {
        exercises.remove(atOffsets: indexSet)
    }
    
    func moveExercise(from source: IndexSet, to destination: Int) {
        exercises.move(fromOffsets: source, toOffset: destination)
    }
    
    func addWorkout () {
        if workouts.contains(where: { $0.title == title }) {
//          display error that this workout already exists
            hasError = true
        } else {
            // don't create duplicate templates of exercises
            var completeExercises = [ExerciseTemplate]()
            var alreadyExercises = [ExerciseTemplate]()
            for exercise in exercises {
                if let existingExercise = existingExercises.first(where: { $0.name == exercise.name && $0.numOfSets == exercise.numOfSets }) {
                    print(existingExercise)
                    alreadyExercises.append(existingExercise)
                } else {
                    completeExercises.append(exercise)
                }
            }
            
            let workoutToAdd = WorkoutTemplate(title: title, exercises: completeExercises, category: category)
            modelContext.insert(workoutToAdd)
            
            // append without inserting ( will create new versions of exercises )
            for ex in alreadyExercises {
                workoutToAdd.exercises.append(ex)
            }
            
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
            Section {
                List {
                    ForEach($exercises) { $exercise in
                        HStack {
                            Text("\(exercise.numOfSets)")
                            Text(exercise.name)
                        }
                    }
                    .onDelete(perform: deleteExercise)
                    .onMove(perform: moveExercise)
                }
                AddExerciseTemplateView(exercises: $exercises)
            } header: {
                HStack {
                    Text("Exercises")
                        .font(.subheadline)
                    Spacer()
                    EditButton()
                        .font(.subheadline)
                        .disabled(exercises.count == 0)
                    
                }
            }
        }
        .alert("Error", isPresented: $hasError) {
            Button("OK") {}
        } message: {
            Text("Workout titled \(title) already exists.")
        }
        .toolbar {
            Button(action: addWorkout) {
                Image(systemName: "plus")
            }
            .disabled(exercises.count == 0 || title == "")
        }
    }
}

#Preview {
    AddTemplateView()
}
