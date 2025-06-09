//
//  ComposerBread.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 10/06/25.
//

import SwiftUI

struct ComposerBread: View {
    @Environment(\.ingredientStore) var ingredientStore
    @State private var isShownBread = false
    @Binding var draftComposer: Ingredient
    
    var body: some View {
        Button {
            isShownBread.toggle()
        } label: {
            ZStack {
                Image(draftComposer.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: .infinity, height: 80)
                    .cornerRadius(10)
                    .padding()
                
                Text(draftComposer.name)
            }
            .foregroundStyle(.white)
            .font(.title)
        }
        .sheet(isPresented: $isShownBread) {
            NavigationStack {
                IngredientList(
                    ingredients: ingredientStore.ingredients(ofCategory: IngredientCategory.buns),
                    onIngredientSelected: { ingredient in
                        draftComposer = ingredient
                    })
                .navigationTitle("Ingredients")
            }
        }
    }
}

#Preview {
    ComposerBread(draftComposer: .constant(Composer().top))
        .environmentObject(UserModel())
        .modelContainer(PreviewData.makeModelContainer(withSampleData: true))
}
