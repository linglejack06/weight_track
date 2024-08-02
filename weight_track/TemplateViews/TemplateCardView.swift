//
//  TemplateCardView.swift
//  weight_track
//
//  Created by Jack Lingle on 7/29/24.
//

import SwiftUI

struct TemplateCardView: View {
    let template: WorkoutTemplate
    var setCount: Int {
        var count = 0
        for exercise in template.exercises {
            count += exercise.numOfSets
        }
        return count
    }
    var body: some View {
        NavigationLink {
            TemplateFullView(template: template)
        } label: {
            HStack {
                VStack (alignment: .leading) {
                    Text(template.title)
                        .font(.headline)
                    Text("Category: \(template.category)")
                        .font(.footnote)
                        .foregroundStyle(Color.secondary)
                }
            }
        }
    }
}
