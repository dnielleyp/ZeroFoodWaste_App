//
//  FoodData.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 5/6/2023.
//

import UIKit

class FoodData: NSObject, Decodable {
    var recipeList: [RecipeData]?
}

private enum CodingKeys: String, CodingKey {
    case recipes = "meals"
}
