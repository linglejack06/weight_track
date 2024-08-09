//
//  PreviousSetListView.swift
//  weight_track
//
//  Created by Jack Lingle on 8/9/24.
//

import SwiftUI

struct PreviousSetListView: View {
    let previousSets: [Set]
    let useSuggestion: (Set) -> Void
    private var alreadyShownSets: [Set] = []
    
    init(previousSets: [Set] = [], useSuggestion: @escaping (Set) -> Void) {
        var noDuplicates: [Set] = []
        for set in previousSets {
            if noDuplicates.contains(where: {$0.weight == set.weight && $0.reps == set.reps }) {
                continue
            } else {
                noDuplicates.append(set)
            }
        }
        
        self.previousSets = noDuplicates
        self.useSuggestion = useSuggestion
    }
    var body: some View {
        ForEach(previousSets) { previousSet in
            Button { useSuggestion(previousSet) } label: {
                HStack {
                    Image(systemName: "dumbbell")
                    Text(String(format: "%.2f", previousSet.weight) + " \(previousSet.unit.rawValue)")
                    Text("\(previousSet.reps) Reps")
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .foregroundStyle(Color.secondary)
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .padding(4)
        .presentationCompactAdaptation(.popover)
    }
}

