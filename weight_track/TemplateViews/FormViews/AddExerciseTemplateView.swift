//
//  AddExerciseTemplateView.swift
//  weight_track
//
//  Created by Jack Lingle on 7/31/24.
//

import SwiftUI
import SwiftData

struct AddExerciseTemplateView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var existingExercises: [ExerciseTemplate]
    @State private var exerciseName = ""
    @State private var numOfSets: Int? = nil
    @State private var exerciseSuggestions = [ExerciseTemplate]()
    @State private var presentPopover = false
    @Binding var exercises: [ExerciseTemplate]
    
    func addExercise () {
        let exerciseToAdd = ExerciseTemplate(numOfSets: numOfSets!, name: exerciseName)

        withAnimation {
            exercises.append(exerciseToAdd)
        }
        exerciseName = ""
        numOfSets = nil
    }
    
    func deleteExercise (_ indexSet: IndexSet) {
        exercises.remove(atOffsets: indexSet)
    }
    
    func moveExercise(from source: IndexSet, to destination: Int) {
        exercises.move(fromOffsets: source, toOffset: destination)
    }
    
    // finds similar exercises by name and limits to 5
    func findExerciseSuggestions(for name: String) {
        if (name == "") {
            exerciseSuggestions = []
        }
        exerciseSuggestions = Array(
            existingExercises.filter({
                $0.name.localizedCaseInsensitiveContains(name)
            })
            .prefix(3)
        )
        if (exerciseSuggestions.count > 0) {
            presentPopover = true
        } else {
            presentPopover = false
        }
    }
    
    func useSuggestion(_ exercise: ExerciseTemplate) {
        exerciseName = exercise.name
        numOfSets = exercise.numOfSets
    }
    var body: some View {
        List {
            ForEach($exercises) { $exercise in
                ExerciseRowView(exercise: exercise)
            }
            .onDelete(perform: deleteExercise)
            .onMove(perform: moveExercise)
        }
        HStack {
            TextField("Name", text: $exerciseName)
                .containerRelativeFrame(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/, count: 2, span: 1, spacing: 0)
                .onChange(of: exerciseName){ oldValue, newValue in
                    findExerciseSuggestions(for: newValue)
                }
                .popover(isPresented: $presentPopover, arrowEdge: .bottom) {
                    VStack(alignment: .leading) {
                        ForEach(exerciseSuggestions) { exercise in
                            Button {
                                useSuggestion(exercise)
                            } label: {
                                HStack {
                                    Image(systemName: "dumbbell")
                                    Text(exercise.name)
                                    Text("\(exercise.numOfSets) sets")
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .foregroundStyle(Color.secondary)
                        }
                    }
                    .padding(4)
                    .presentationCompactAdaptation(.popover)
                }
            TextField("Sets", value: $numOfSets, format: .number)
                .keyboardType(.numberPad)
            Button(action: addExercise) {
                Image(systemName: "plus")
            }
            .disabled(exerciseName == "" || numOfSets == nil || numOfSets == 0)
        }
    }
}
