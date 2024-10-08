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
    @State private var minutes: Int? = nil
    @State private var seconds: Int? = nil
    @State private var exerciseSuggestions = [ExerciseTemplate]()
    @State private var presentPopover = false
    @State private var isNameEmpty = true
    @State private var isSetsNil = true
    @State private var isMinutesNil = true
    @State private var isSecondsNil = true
    @Binding var exercises: [ExerciseTemplate]
    
    func addExercise () {
        let minutesUnwrapped = Double(minutes ?? 0)
        let secondsUnwrapped = Double(seconds ?? 0)
        let restBetweenSets: Double = minutesUnwrapped * 60.0 + secondsUnwrapped
        
        let exerciseToAdd = ExerciseTemplate(numOfSets: numOfSets!, name: exerciseName, restBetweenSets: restBetweenSets)

        withAnimation {
            exercises.append(exerciseToAdd)
        }
        exerciseName = ""
        numOfSets = nil
        minutes = nil
        seconds = nil
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
        minutes = Int(exercise.restBetweenSets / 60)
        seconds = Int(exercise.restBetweenSets.truncatingRemainder(dividingBy: 60))
        presentPopover = false
    }
    var body: some View {
        List {
            ForEach($exercises) { $exercise in
                ExerciseRowView(exercise: exercise)
            }
            .onDelete(perform: deleteExercise)
            .onMove(perform: moveExercise)
        }
        VStack (alignment: .center) {
            HStack (alignment: .center){
                LabelledTextInput(title: "Name", isNil: $isNameEmpty) {
                    TextField("", text: $exerciseName)
                        .onChange(of: exerciseName){ oldValue, newValue in
                            findExerciseSuggestions(for: newValue)
                            isNameEmpty = newValue.isEmpty
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
                }
                .containerRelativeFrame(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/, count: 2, span: 1, spacing: 0)
                LabelledTextInput(title: "Sets", isNil: $isSetsNil) {
                    TextField("", value: $numOfSets, format: .number)
                        .keyboardType(.numberPad)
                        .onChange(of: numOfSets) { oldValue, newValue in
                            isSetsNil = (newValue==nil)
                        }
                }
            }
            .padding(.bottom, 8)
            VStack (alignment: .leading, spacing: 0) {
                Text("Rest Between Sets")
                    .font(.caption)
                HStack {
                    LabelledTextInput(title: "Minutes", isNil: $isMinutesNil) {
                        TextField("", value: $minutes, format: .number)
                            .keyboardType(.numberPad)
                            .onChange(of: minutes) { oldValue, newValue in
                                isMinutesNil = (newValue==nil)
                            }
                    }
                    LabelledTextInput(title: "Seconds", isNil: $isSecondsNil) {
                        TextField("", value: $seconds, format: .number)
                            .keyboardType(.numberPad)
                            .onChange(of: seconds) { oldValue, newValue in
                                isSecondsNil = (newValue==nil)
                            }
                    }
                }
            }
            .padding(.bottom, 8)
            Button(action: addExercise) {
                Text("Add Exercise")
            }
            .buttonStyle(BorderedProminentButtonStyle())
            .disabled(exerciseName == "" || numOfSets == nil || numOfSets == 0 || (minutes == nil && seconds == nil))
        }
    }
}
