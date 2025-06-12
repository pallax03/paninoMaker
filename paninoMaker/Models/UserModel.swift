//
//  UserModel.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

enum UserGamifications {
    static let enableGamification: Bool = false
    static let levelCap = 5
    static let pointsPerLevelUp: Int = 200
}

@MainActor
class UserModel: ObservableObject {
    @Published var username: String = "Guest"
    @Published var level: Int = 0
    @Published var pex: Int = 0
    @Published var isLogged: Bool = false
    @Published var propicData: Data?
    
    private let db = Firestore.firestore()
    
    var propic: UIImage? {
        guard let data = propicData else { return nil }
        return UIImage(data: data)
    }
    
    func setPropic(_ image: UIImage) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        // Resize propic (max 512x512)
        let targetSize = CGSize(width: 512, height: 512)
        let resizedImage: UIImage = {
            let size = image.size
            let widthRatio = targetSize.width / size.width
            let heightRatio = targetSize.height / size.height
            let scaleFactor = min(widthRatio, heightRatio)
            let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)

            UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return newImage ?? image
        }()

        // Compress to 0.5 quality
        if let data = resizedImage.jpegData(compressionQuality: 0.4) {
            self.propicData = data
            let base64String = data.base64EncodedString()

            // Save in Firestore field
            db.collection("users").document(uid).setData([
                "profileImageBase64": base64String
            ], merge: true)
        }
    }
    
    func syncUserData() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.username = Auth.auth().currentUser?.email ?? "no email"
        let ref = db.collection("users").document(uid)
        
        do {
            let snapshot = try await ref.getDocument()
            if let data = snapshot.data() {
                self.pex = data["pex"] as? Int ?? 0
                self.level = self.pex / UserGamifications.pointsPerLevelUp
                self.isLogged = true

                // ✅ Caricamento immagine da stringa base64 (non da Storage)
                if let base64String = data["profileImageBase64"] as? String,
                   let imageData = Data(base64Encoded: base64String) {
                    self.propicData = imageData
                }

            } else {
                // Documento non esiste: crea con valori iniziali
                try await ref.setData([
                    "pex": 0,
                    "level": 0
                ])
                self.pex = 0
                self.level = 0
                self.isLogged = true
            }
        } catch {
            print("Errore fetch Firestore: \(error)")
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            self.isLogged = false
        } catch {
            print("Errore durante il logout: \(error.localizedDescription)")
        }
        unlockAll()
    }
    
    func deleteUserAccount(onError: @escaping (String) -> Void, onSuccess: @escaping () -> Void) {
            guard let user = Auth.auth().currentUser else {
                onError("Nessun utente autenticato.")
                return
            }
            let userRef = db.collection("users").document(user.uid)
            userRef.delete { error in
                if let error = error {
                    onError("Errore durante l'eliminazione dei dati Firestore: \(error.localizedDescription)")
                } else {
                    user.delete { error in
                        if let error = error {
                            onError("Errore nell'eliminazione account: \(error.localizedDescription)")
                        } else {
                            self.isLogged = false
                            self.unlockAll()
                            onSuccess()
                            print("Account e dati eliminati.")
                        }
                    }
                }
            }
        }
    
    func saveUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).setData([
            "pex": pex,
            "level": level
        ], merge: false)
    }
    
    func levelUp(points: Int) {
        self.pex = points
        self.level = self.isLevelUpAvailable(self.pex / UserGamifications.pointsPerLevelUp)
        self.saveUserData()
    }
    
    func isLevelUpAvailable(_ lvl: Int) -> Int {
        if level < lvl {
            sendNotification(lvl, message: "salito ")
        } else if level > lvl {
            sendNotification(lvl, message: "sceso ")
        }
        return lvl
    }
    
    func unlockAll() {
        username = "Guest"
        pex = UserGamifications.levelCap * UserGamifications.pointsPerLevelUp
        level = UserGamifications.levelCap
    }
}
