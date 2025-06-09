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
    static let pointsPerLevelUp: Int = 100
}

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
        if let data = image.jpegData(compressionQuality: 0.8) {
            self.propicData = data
            let ref = Storage.storage().reference().child("profileImages/\(uid).jpg")
            ref.putData(data, metadata: nil) { _, _ in
                ref.downloadURL { url, _ in
                    if let url = url {
                        self.db.collection("users").document(uid).setData([
                            "profileImageURL": url.absoluteString
                        ], merge: true)
                    }
                }
            }
        }
    }
    
    func syncUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.username = Auth.auth().currentUser?.email ?? "no email"
        let ref = db.collection("users").document(uid)
        ref.getDocument { snapshot, error in
            if let data = snapshot?.data() {
                self.pex = data["pex"] as? Int ?? 0
                self.level = self.pex / UserGamifications.pointsPerLevelUp
                self.isLogged = true
                
                if let urlStr = data["profileImageURL"] as? String,
                   let url = URL(string: urlStr) {
                    self.downloadImage(from: url)
                }
            } else {
                ref.setData([
                    "pex": 0,
                    "level": 0
                ])
            }
        }
        self.isLogged = true
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            self.isLogged = false
            unlockAll()
        } catch {
            print("Errore durante il logout: \(error.localizedDescription)")
        }
    }
    
    func saveUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).setData([
            "pex": pex,
            "level": level
        ], merge: true)
    }
    
    private func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                self.propicData = data
            }
        }.resume()
    }
    
    func levelUp(points: Int) {
        pex += points
        level = isLevelUpAvailable(pex / UserGamifications.pointsPerLevelUp)
        saveUserData()
    }
    
    func isLevelUpAvailable(_ lvl: Int) -> Int {
        let newLevel = min(UserGamifications.levelCap, lvl)
        if level != newLevel {
            sendNotification(newLevel)
        }
        return newLevel
    }
    
    func unlockAll() {
        username = "Master User"
        pex = 2405
        level = UserGamifications.levelCap
    }
}
