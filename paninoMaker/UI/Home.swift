//
//  Home.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 27/05/25.
//

import SwiftUI

struct Home: View {
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        
                    } label: {
                        Text("Menu")
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                    .padding(.trailing, 20)
                    
                    NavigationLink(destination: PaninoView()) {
                        Image(systemName: "plus")
                            .font(.title)
                    }
                }
                .padding()
                
                HStack {
                    Text("Menu Home")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                
            }
        }
    }
}

#Preview {
    Home()
}
