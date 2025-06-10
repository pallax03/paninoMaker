//
//  PaninoRow.swift
//  paninoMaker
//
//  Created by alex mazzoni on 28/05/25.
//

import SwiftUI
import MapKit

struct PaninoRow: View {
    @EnvironmentObject var user: UserModel
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    let panino: Panino
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ComposerPreview(composer: panino.composer)
                
                VStack(spacing: 10) {
                    if !panino.images.isEmpty {
                        Image(uiImage: panino.images.first!)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .frame(maxWidth: 200, maxHeight: 150)
                    }
                    
                    if panino.coordinates != nil {
                        Map(position: $cameraPosition) {
                            Annotation(panino.name, coordinate: panino.coordinates!) {
                                Text("🍔")
                                    .font(.title)
                            }
                        }
                        .cornerRadius(10)
                        .frame(maxWidth: 200, maxHeight: 150)
                    }
                }
                .padding()
            }
            
            HStack {
                VStack(alignment: .leading) {
                    
                    Text(panino.name)
                    
                    HStack {
                        Image(systemName: "folder.fill")
                        
                        Text(panino.menu?.title ?? SidebarSection.all.title)
                            .font(.caption)
                            .fontWeight(.light)
                            .foregroundStyle(.secondary)
                    }
                    .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(panino.owner ?? "no user")
                    Text("\(panino.points) PEX \(!user.isLogged ? "⚠️" : "")")
                        .font(.caption)
                        .fontWeight(.light)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    PaninoRow(panino: PreviewData.samplePanino)
        .environmentObject(UserModel())
}
