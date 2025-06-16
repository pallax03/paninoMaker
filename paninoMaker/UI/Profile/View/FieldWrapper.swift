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
    @FocusState var focused: Bool
    
    init(condition: Binding<String>, placeholder: String, @ViewBuilder content: () -> Content) {
        self._condition = condition
        self.placeholder = placeholder
        self.content = content()
    }
    
    var body: some View {
        let isActive = focused || condition.count > 0
        ZStack(alignment: isActive ? .topLeading : .center) {
            content
                .foregroundStyle(.black)
                .font(.system(size: 16, weight: .regular))
                .opacity(isActive ? 1 : 0)
                .offset(y: 7)
                .focused($focused)
            
            HStack {
                Text(placeholder)
                    .foregroundColor(.black.opacity(0.3))
                    .frame(height: 16)
                    .font(.system(size: isActive ? 12 : 16, weight: .regular))
                    .offset(y: isActive ? -7 : 0)
                Spacer()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            focused.toggle()
        }
        .animation(.smooth(duration: 0.1), value: focused)
        .frame(height: 56)
        .padding(.horizontal, 16)
        .background(.white)
        .cornerRadius(12)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(focused ? .black.opacity(0.6) : .black.opacity(0.2), lineWidth: 2)
        }
    }
}

#Preview {
    FieldWrapper(condition: .constant(""), placeholder: "Email") {
        TextField("", text: .constant(""))
            .textContentType(.emailAddress)
            .autocapitalization(.none)
    }
    FieldWrapper(condition: .constant(""), placeholder: "Password") {
        SecureField("", text: .constant(""))
    }
}
