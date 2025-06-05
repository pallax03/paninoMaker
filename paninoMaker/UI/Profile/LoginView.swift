//
//  LoginView.swift
//  paninoMaker
//
//  Created by alex mazzoni on 05/06/25.
//

import SwiftUI


struct LoginView: View {
    @StateObject var viewModel = AuthModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

            Button("Login") {
                Task {
                    await viewModel.login()
                }
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                Task {
                    await viewModel.signInWithGoogle()
                }
            } label: {
                Label("Continua con Google", systemImage: "globe")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
