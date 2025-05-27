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
            
            HStack {
                ForEach(0..<6) { _ in
                    VStack {
                        Badge()
                        
                        Text("x 0")
                    }
                }
            }
        }
        .padding()
    }
}

struct Badge: View {
    var body: some View {
        Circle()
            .fill(Color.white)
            .overlay {
                Circle().stroke(Color.green, lineWidth: 2)
        }
    }
}

#Preview {
    ProfileView()
}
