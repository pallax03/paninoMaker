//
//  FieldWrapper.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 10/06/25.
//

import SwiftUI

struct FieldWrapper<Content: View>: View {
    @Binding var condition: String
    let placeholder: String
    let content: Content
    
    init(condition: Binding<String>, placeholder: String, @ViewBuilder content: () -> Content) {
        self._condition = condition
        self.placeholder = placeholder
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if condition.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .offset(x:20, y: 0)
            } else {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .font(.caption)
                    .offset(x:10, y: -10)
            }

            content
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.07), radius: 4, x: 0, y: 2)
    }
}

//#Preview {
//    FieldWrapper(condition: .constant(""), placeholder: "Test") {
//        Image(systemName: "plus")
//    }
//}
