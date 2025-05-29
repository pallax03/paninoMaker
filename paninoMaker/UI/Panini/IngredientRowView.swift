//
//  IngredientRow.swift
//  paninoMaker
//
//  Created by alex mazzoni on 28/05/25.
//

import SwiftUI

struct IngredientRowView: View {
    @EnvironmentObject var user: UserModel
    
    let ingredient: Ingredient
    
    var body: some View {
        HStack(alignment: .center) {
            
            VStack(alignment: .leading) {
                Text(ingredient.name)
                    .font(.headline)
                Text(ingredient.tags.map { $0.rawValue.capitalized }.joined(separator: ", "))
            }
            
            Spacer()
            
            let isUnlocked = ingredient.unlockLevel <= user.level
            Image(systemName: isUnlocked ? "checkmark.circle.fill" : "lock.fill")
                .foregroundColor(isUnlocked ? .green : .gray)
        }
    }
}

#Preview {
    IngredientRowView(ingredient: IngredientStore().ingredients.randomElement()!)
        .environmentObject(UserModel())
}
