//
//  AuthModel.swift
//  paninoMaker
//
//  Created by alex mazzoni on 05/06/25.
//

import FirebaseAuth
import SwiftUI
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift

@MainActor
class AuthModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    
    func register(_ user: UserModel) async {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            print("✅ Registrazione riuscita")
            await login(user)
        } catch {
            errorMessage = error.localizedDescription
            user.logout()
        }
    }
    
    func login(_ user: UserModel) async {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            print("✅ Login riuscito per:", result.user.email ?? "-")
            await user.syncUserData()
        } catch {
            errorMessage = error.localizedDescription
            user.logout()
        }
    }
    
    func signInWithGoogle(_ user: UserModel) async {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            errorMessage = "Errore configurazione Firebase"
            return
        }

        _ = GIDConfiguration(clientID: clientID)

        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = scene.windows.first?.rootViewController else {
            errorMessage = "Impossibile trovare finestra principale"
            return
        }

        func performSignIn() async throws {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)
            let idToken = result.user.idToken?.tokenString ?? ""
            let accessToken = result.user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            _ = try await Auth.auth().signIn(with: credential)
            await user.syncUserData()
        }

        var attempts = 0
        while attempts < 3 {
            do {
                try await performSignIn()
                return
            } catch {
                attempts += 1

                if let urlError = error as? URLError, urlError.code == .networkConnectionLost {
                    print("Tentativo \(attempts): Connessione persa. Riprovo...")
                    try? await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(attempts)) * 1_000_000_000)) // backoff esponenziale
                    continue
                } else {
                    errorMessage = error.localizedDescription
                    user.logout()
                    return
                }
            }
        }

        errorMessage = "Connessione persa durante il login con Google. Riprova più tardi."
        user.logout()
    }
}
