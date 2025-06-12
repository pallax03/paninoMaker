//
//  DeleteAccount.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 12/06/25.
//

import SwiftUI
import LocalAuthentication
import FirebaseAuth
import FirebaseFirestore

struct DeleteAccount: View {
    @EnvironmentObject var userModel: UserModel
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            Button {
                showAlert = true
            } label: {
                Text("Delete account")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .alert("Sei sicuro di voler eliminare questo account?", isPresented: $showAlert) {
            Button("Annulla", role: .cancel) {}
            Button("Continua", role: .destructive) {
                authenticateAndDelete()
            }
        } message: {
            Text("Questa azione è irreversibile.")
        }
        .alert("Errore", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    func authenticateAndDelete() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Autenticati per eliminare l'account"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        deleteUserDataAndAccount()
                    } else {
                        self.errorMessage = "Autenticazione fallita."
                        self.showError = true
                    }
                }
            }
        } else {
            self.errorMessage = "Autenticazione biometrica non disponibile."
            self.showError = true
        }
    }

    func deleteUserDataAndAccount() {
        guard let user = Auth.auth().currentUser else {
            self.errorMessage = "Nessun utente autenticato."
            self.showError = true
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)

        userRef.delete { error in
            if let error = error {
                self.errorMessage = "Errore durante l'eliminazione dei dati Firestore: \(error.localizedDescription)"
                self.showError = true
            } else {
                user.delete { error in
                    DispatchQueue.main.async {
                        if let error = error {
                            self.errorMessage = "Errore nell'eliminazione account: \(error.localizedDescription)"
                            self.showError = true
                        } else {
                            userModel.isLogged = false
                            userModel.unlockAll()
                            dismiss()
                            print("Account e dati eliminati.")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DeleteAccount()
        .environmentObject(UserModel())
        .environmentObject(ThemeManager())
        .modelContainer(PreviewData.makeModelContainer())
}
