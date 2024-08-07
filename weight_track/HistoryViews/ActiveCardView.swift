//
//  ActiveCardView.swift
//  weight_track
//
//  Created by Jack Lingle on 8/5/24.
//

import SwiftUI

struct ActiveCardView: View {
    let activeWorkout: ActiveWorkout
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text(activeWorkout.template.title)
                    .font(.headline)
                Text("Category: \(activeWorkout.template.category)")
                    .font(.footnote)
                    .foregroundStyle(Color.secondary)
            }
            Spacer()
            Spacer()
            VStack (alignment: .leading) {
                Text(activeWorkout.date, format: .dateTime.day().month().year())
                    .font(.headline)
                Text("At \(activeWorkout.date.formatted(date: .omitted, time: .shortened))")
                    .font(.footnote)
                    .foregroundStyle(Color.secondary)
            }
            Spacer()
        }
    }
}

