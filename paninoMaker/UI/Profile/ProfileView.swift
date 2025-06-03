//
//  ProfileView.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Panino.creationDate, order: .reverse) var allPanini: [Panino]
    @EnvironmentObject var user: UserModel
    
    
    var body: some View {
        VStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 150)
                .overlay {
                    Circle().stroke(.black, lineWidth: 2)
                }
            
            Text(user.username)
                .font(.title)
            
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 200)
                    .overlay {
                        Circle().stroke(.red, lineWidth: 4)
                    }
                
                VStack {
                    Text("LVL. \(user.level)")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("\(user.pex) PEX")
                        .fontWeight(.bold)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "info.circle")
                }
                .foregroundStyle(.gray)
                .offset(x: 55,y: -25)
            }
            .foregroundStyle(.red)
            .padding()
            
            VStack {
                ForEach(BadgesLibrary.all, id: \.title) { badge in
                    HStack {
                        let count = allPanini.filter {
                            $0.badges.contains {$0.title == badge.title}
                        }.count
                        badge.view
                            .opacity( count > 0 ? 1.0 : 0.3)
                        Text("\(count)x")
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ProfileView()
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
        .environmentObject(UserModel())
}
