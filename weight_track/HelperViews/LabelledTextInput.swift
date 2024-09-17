//
//  LabelledTextInput.swift
//  weight_track
//
//  Created by Jack Lingle on 9/7/24.
//
//  Inspired By Peter Friese: https://www.youtube.com/watch?time_continue=735&v=Sg0rfYL3utI&embeds_referring_euri=https%3A%2F%2Fwww.google.com%2F&source_ve_path=MTM5MTE3LDI4NjY2

import SwiftUI

enum TextInputType {
    case double
    case string
    case int
}

enum InitError: Error {
    case wrongInputType
}


struct LabelledTextInput<Content>: View where Content: View{
    var title: String
    var content: Content
    @State private var offsetEffect: CGFloat = 0
    @State private var scaleEffect: Double = 1
    @Binding var isNil: Bool
    
    init(title: String, isNil: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self._isNil = isNil
        self.content = content()
    }
    
    
    var body: some View {
            ZStack(alignment: .leading) {
                Text(title)
                    .foregroundStyle(isNil ? .gray : .accentColor)
                    .offset(y: offsetEffect)
                    .scaleEffect(scaleEffect, anchor: .leading)
                    .onChange(of: isNil) { oldValue, newValue in
                        if !newValue {
                            offsetEffect = -25
                            scaleEffect = 0.8
                        } else {
                            offsetEffect = 0
                            scaleEffect = 1
                        }
                    }
                content
            }
            .padding(.top, 15)
            .animation(.default, value: offsetEffect)
            .animation(.default, value: scaleEffect)
    }
}
