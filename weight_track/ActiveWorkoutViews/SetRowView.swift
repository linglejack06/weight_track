//
//  SetRowView.swift
//  weight_track
//
//  Created by Jack Lingle on 8/7/24.
//

import SwiftUI

struct SetRowView: View {
    let set: Set
    var body: some View {
        HStack {
            Text(String(format: "%.2f", set.weight) + " \(set.unit.rawValue)")
            Spacer()
            Text("\(set.reps) Reps")
        }
    }
}
