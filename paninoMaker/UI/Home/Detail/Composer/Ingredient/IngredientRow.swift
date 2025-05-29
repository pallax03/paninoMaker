//
//  IngredientRow.swift
//  paninoMaker
//
//  Created by alex mazzoni on 28/05/25.
//

import SwiftUI

struct IngredientRow: View {
    @EnvironmentObject var user: UserModel
    @Environment(\.dismiss) var dismiss
    
    let ingredient: Ingredient
    let onSelect: (Ingredient) -> Void
    
    var body: some View {
        let isUnlocked = ingredient.unlockLevel <= user.level
        
        if isUnlocked {
            Button {
                onSelect(ingredient)
                dismiss()
            } label: {
                HStack(alignment: .center) {
                    
                    VStack(alignment: .leading) {
                        Text(ingredient.name)
                            .font(.headline)
                        Text(ingredient.tags.map { $0.rawValue.capitalized }.joined(separator: ", "))                    }
                    .foregroundStyle(.black)
                    
                    Spacer()
                    
                    
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
                .padding(.vertical, 4)
            }
        } else {
            HStack(alignment: .center) {
                
                VStack(alignment: .leading) {
                    Text(ingredient.name)
                        .font(.headline)
                    Text(ingredient.tags.map { $0.rawValue.capitalized }.joined(separator: ", "))
                }
                
                Spacer()
                
                Image(systemName: "lock.fill")
            }
            .padding(.vertical, 4)
            .foregroundStyle(.gray)
        }
        
    }
}

//#Preview {
//    IngredientRow(ingredient: IngredientStore().ingredients.randomElement()!)
//        .environmentObject(UserModel())
//}
