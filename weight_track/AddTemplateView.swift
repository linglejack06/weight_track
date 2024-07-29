//
//  AddTemplateView.swift
//  weight_track
//
//  Created by Jack Lingle on 7/29/24.
//

import SwiftUI

struct AddTemplateView: View {
    @State private var title = ""
    @State private var category: WorkoutCategory = .push
    @State private var exerciseName = ""
    @State private var numOfSets = 0
    @State private var exercises: [ExerciseTemplate] = []
    
    func addExercise () {
        let exercise = ExerciseTemplate(numOfSets: numOfSets, name: exerciseName)
        withAnimation {
            exercises.append(exercise)
        }
        exerciseName = ""
        numOfSets = 0
    }
    
    func deleteExercise (_ indexSet: IndexSet) {
        exercises.remove(atOffsets: indexSet)
    }
    
    func addWorkout () {
        
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
