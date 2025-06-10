//
//  LoginView.swift
//  paninoMaker
//
//  Created by alex mazzoni on 05/06/25.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = AuthModel()
    @EnvironmentObject var user: UserModel
    @State private var isRegistrating: Bool = false
    @Query(filter: #Predicate { !$0.inTrash }, sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Icon
            Image("panino")
                .resizable()
                .frame(width: 150, height: 150)
            
            // Title
            Text(isRegistrating ? "Registrati" : "Accedi")
                .font(.largeTitle)
                .bold()
            
            // Email field
            FieldWrapper(condition: $viewModel.email, placeholder: "Email") {
                TextField("", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
            }
            
            // Password field
            FieldWrapper(condition: $viewModel.password, placeholder: "Password") {
                SecureField("", text: $viewModel.password)
            }
            
            // Error message
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            
            // Confirm button
            ZStack {
                if isLoading {
                    ProgressView()
                        .tint(.orange)
                        .transition(.opacity.combined(with: .scale))
                } else {
                    Button {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            isLoading = true
                        }
                        Task {
                            if isRegistrating {
                                await viewModel.register(user)
                            } else {
                                await viewModel.login(user)
                            }
                            
                            withAnimation(.easeInOut(duration: 0.25)) {
                                isLoading = false
                            }
                            
                            if user.isLogged {
                                GamificationManager.shared.prepareForUser(user, panini: allPanini)
                                dismiss()
                            }
                        }
                    } label: {
                        Text("Conferma")
                            .foregroundColor(.white)
                            .frame(maxWidth: isLoading ? 0 : .infinity)
                            .transition(.opacity)
                    }
                    .disabled(isLoading)
                }
            }
            .frame(height: 56)
            .animation(.easeInOut(duration: 0.6), value: isLoading)
            .background(isLoading ? .white : Color.orange)
            .cornerRadius(12)
            
            // Registration / login button
            Button {
                isRegistrating.toggle()
            } label: {
                Text(isRegistrating ? "Hai già un account? Accedi" : "Vuoi registrarti?")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            // Divider custom
            ZStack {
                Divider()
                    .background(Color.gray.opacity(0.3))
                
                Text("or")
                    .padding()
                    .background(.background)
                    .foregroundColor(.gray.opacity(0.6))
            }
            
            // Google sign in button
            Button {
                Task {
                    await viewModel.signInWithGoogle(user)
                    
                    if user.isLogged {
                        GamificationManager.shared.prepareForUser(user, panini: allPanini)
                        dismiss()
                    }
                }
            } label: {
                HStack {
                    Image("google")
                        .resizable()
                        .scaledToFit()
                    
                    Text("Continue with Google")
                }
                .padding()
                .foregroundStyle(.gray)
                .frame(height: 56)
                .padding(.horizontal, 16)
                .background(.white)
                .cornerRadius(12)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.black.opacity(0.2), lineWidth: 2)
                }
                .contentShape(Rectangle())

            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
        .environmentObject(UserModel())
        .modelContainer(PreviewData.makeModelContainer())
}
