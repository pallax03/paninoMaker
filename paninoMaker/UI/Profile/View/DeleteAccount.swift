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
    @EnvironmentObject var user: UserModel
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
                        user.deleteUserAccount(onError: { message in
                            self.errorMessage = message
                            self.showError = true
                        }, onSuccess: {
                            dismiss()
                        })
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
}

#Preview {
    DeleteAccount()
        .environmentObject(UserModel())
        .environmentObject(ThemeManager())
        .modelContainer(PreviewData.makeModelContainer())
}
