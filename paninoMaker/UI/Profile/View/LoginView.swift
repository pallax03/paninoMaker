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
            Image("Panino")
                .resizable()
                .frame(width: 150, height: 150)
            Text(isRegistrating ? "Registrati" : "Accedi")
                .font(.largeTitle)
                .bold()

            ZStack(alignment: .leading) {
                if viewModel.email.isEmpty {
                    Text("Email")
                        .foregroundColor(.gray)
                        .offset(x:20, y: 0)
                } else {
                    Text("Email")
                        .foregroundColor(.gray)
                        .font(.caption)
                        .offset(x:10, y: -10)
                }

                TextField("", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.horizontal, 16)
                    .padding(.top, 26)
                    .padding(.bottom, 8)
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.07), radius: 4, x: 0, y: 2)

            ZStack(alignment: .leading) {
                if viewModel.password.isEmpty {
                    Text("Password")
                        .foregroundColor(.gray)
                        .offset(x:20, y: 0)
                } else {
                    Text("Password")
                        .foregroundColor(.gray)
                        .font(.caption)
                        .offset(x:10, y: -10)
                }

                SecureField("", text: $viewModel.password)
                    .padding(.horizontal, 16)
                    .padding(.top, 26)
                    .padding(.bottom, 8)
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.07), radius: 4, x: 0, y: 2)

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
                Text("Conferma")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            
            Button {
                isRegistrating.toggle()
            } label: {
                Text(isRegistrating ? "Hai già un account? Accedi" : "Vuoi registrarti?")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .onChange(of: isRegistrating) { oldValue, newValue in
                $viewModel.email.wrappedValue = ""
                $viewModel.password.wrappedValue = ""
            }

            ZStack {
                Divider()
                    .background(Color.gray.opacity(0.3))
                
                Text("or")
                    .padding()
                    .background(.background)
                    .foregroundColor(.gray.opacity(0.6))
            }
            
            GoogleSignInButton(scheme: .dark, style: .standard, state: .normal) {
                Task {
                    await viewModel.signInWithGoogle(user)
                    
                    if user.isLogged {
                        GamificationManager.shared.prepareForUser(user, panini: allPanini)
                        dismiss()
                    }
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
