//
//  LoginView.swift
//  paninoMaker
//
//  Created by alex mazzoni on 05/06/25.
//

import SwiftUI
import GoogleSignInSwift
import SwiftData

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = AuthModel()
    @EnvironmentObject var user: UserModel
    @State private var isRegistrating: Bool = false
    @Query(filter: #Predicate { !$0.inTrash }, sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]

    var body: some View {
        VStack(spacing: 20) {
            Text(isRegistrating ? "Register" : "Login")
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

            Button {
                Task {
                    if isRegistrating {
                        await viewModel.register(user)
                    } else {
                        await viewModel.login(user)
                    }
                    
                    if user.isLogged {
                        GamificationManager.shared.prepareForUser(user, panini: allPanini)
                        dismiss()
                    }
                }
            } label: {
                Text(isRegistrating ? "Conferma" : "Accedi")
                    .font(.title2)
                    .padding(5)
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                isRegistrating.toggle()
            } label: {
                Text(isRegistrating ? "Login" : "Registrati")
                    .font(.subheadline)
            }
            .onChange(of: isRegistrating) { oldValue, newValue in
                $viewModel.email.wrappedValue = ""
                $viewModel.password.wrappedValue = ""
            }

            ZStack {
                Divider()
                
                Text("or")
                    .padding()
                    .background(.background)
                    .foregroundStyle(.gray)
            }
            
            GoogleSignInButton(scheme: .dark, style: .standard, state: .normal) {
                Task {
                    await viewModel.signInWithGoogle(user)
                    
                    if (user.isLogged) {
                        GamificationManager.shared.prepareForUser(user, panini: allPanini)
                        dismiss()
                    }
                }
                
                if user.isLogged {
                    dismiss()
                }
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    LoginView()
        .environmentObject(UserModel())
        .modelContainer(PreviewData.makeModelContainer())
}
