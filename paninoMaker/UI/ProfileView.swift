//
//  Profile.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 150)
                .overlay {
                    Circle().stroke(.black, lineWidth: 2)
                }
            
            Text("Username")
                .font(.title)
            
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 200)
                    .overlay {
                        Circle().stroke(.red, lineWidth: 4)
                    }
                
                VStack {
                    Text("LVL. 0")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Titolo")
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
            
            BadgeView()
        }
        .padding()
    }
}

#Preview {
    ProfileView()
}
