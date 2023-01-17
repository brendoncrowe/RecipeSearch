//
//  RecipeModel.swift
//  RecipeSearch
//
//  Created by Brendon Crowe on 1/17/23.
//

import Foundation

struct RecipeSearch: Decodable {
    let hits: [Hit]
}

struct Hit: Decodable {
    let recipe: Recipe
}

struct Recipe: Decodable {
    let label: String
}
