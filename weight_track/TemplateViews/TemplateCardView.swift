//
//  TemplateCardView.swift
//  weight_track
//
//  Created by Jack Lingle on 7/29/24.
//

import SwiftUI

struct TemplateCardView: View {
    let template: WorkoutTemplate
    var body: some View {
        NavigationLink {
            TemplateFullView(template: template)
        } label: {
            HStack {
                Text(template.title)
                Text("\(template.category.rawValue) Workout")
                Text("\(template.exercises.count) Exercises")
            }
        }
    }
}
