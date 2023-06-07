//
//  FoodData.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 5/6/2023.
//

import UIKit

class FoodData: NSObject, Decodable {
    var recipes: [RecipeData]?
    
    private enum CodingKeys: String, CodingKey {
        case recipes = "meals"
    }
}



class RecipeData: NSObject, Decodable {
    
    var name: String
    var cuisine: String?
    var instructions: [String?]
    var source: String?
    var image: String?
    
    var ingredientsList: [String] = []

    var ing1: String?
    var ing2: String?
    var ing3: String?
    var ing4: String?
    var ing5: String?
    var ing6: String?
    var ing7: String?
    var ing8: String?
    var ing9: String?
    var ing10: String?
    var ing11: String?
    var ing12: String?
    var ing13: String?
    var ing14: String?
    var ing15: String?
    var ing16: String?
    var ing17: String?
    var ing18: String?
    var ing19: String?
    var ing20: String?

    var meas1: String?
    var meas2: String?
    var meas3: String?
    var meas4: String?
    var meas5: String?
    var meas6: String?
    var meas7: String?
    var meas8: String?
    var meas9: String?
    var meas10: String?
    var meas11: String?
    var meas12: String?
    var meas13: String?
    var meas14: String?
    var meas15: String?
    var meas16: String?
    var meas17: String?
    var meas18: String?
    var meas19: String?
    var meas20: String?

    
    
    enum RecipeKeys: String, CodingKey {
        case name = "strMeal"
        case cuisine = "strArea"
        case instructions = "strInstructions"
        case source = "strSource"
        case image = "strMealThumb"

        case strIngredient1
        case strIngredient2
        case strIngredient3
        case strIngredient4
        case strIngredient5
        case strIngredient6
        case strIngredient7
        case strIngredient8
        case strIngredient9
        case strIngredient10
        case strIngredient11
        case strIngredient12
        case strIngredient13
        case strIngredient14
        case strIngredient15
        case strIngredient16
        case strIngredient17
        case strIngredient18
        case strIngredient19
        case strIngredient20

        case strMeasure1
        case strMeasure2
        case strMeasure3
        case strMeasure4
        case strMeasure5
        case strMeasure6
        case strMeasure7
        case strMeasure8
        case strMeasure9
        case strMeasure10
        case strMeasure11
        case strMeasure12
        case strMeasure13
        case strMeasure14
        case strMeasure15
        case strMeasure16
        case strMeasure17
        case strMeasure18
        case strMeasure19
        case strMeasure20
        
    }
    
    required init(from decoder: Decoder) throws {
        
        let recipeContainer = try decoder.container(keyedBy: RecipeKeys.self)
        
        name = try recipeContainer.decode(String.self, forKey: .name)
        cuisine = try? recipeContainer.decode(String.self, forKey: .cuisine)
        var strInstructions = try recipeContainer.decode(String.self, forKey: .instructions)
        
        self.instructions = strInstructions.components(separatedBy: "\r\n")
        
        source = try? recipeContainer.decode(String.self, forKey: .source)
        image = try? recipeContainer.decode(String.self, forKey: .image)
        
        
        ing1 = try? recipeContainer.decode(String.self, forKey: .strIngredient1)
        ing2 = try? recipeContainer.decode(String.self, forKey: .strIngredient2)
        ing3 = try? recipeContainer.decode(String.self, forKey: .strIngredient3)
        meas1 = try? recipeContainer.decode(String.self, forKey: .strMeasure1)
        meas2 = try? recipeContainer.decode(String.self, forKey: .strMeasure2)
        meas3 = try? recipeContainer.decode(String.self, forKey: .strMeasure3)
        
        
        
        
        ing4 = try? recipeContainer.decode(String.self, forKey: .strIngredient4)
        ing5 = try? recipeContainer.decode(String.self, forKey: .strIngredient5)
        ing6 = try? recipeContainer.decode(String.self, forKey: .strIngredient6)
        ing7 = try? recipeContainer.decode(String.self, forKey: .strIngredient7)
        ing8 = try? recipeContainer.decode(String.self, forKey: .strIngredient8)
        ing9 = try? recipeContainer.decode(String.self, forKey: .strIngredient9)
        ing10 = try? recipeContainer.decode(String.self, forKey: .strIngredient10)
        ing11 = try? recipeContainer.decode(String.self, forKey: .strIngredient11)
        ing12 = try? recipeContainer.decode(String.self, forKey: .strIngredient12)
        ing13 = try? recipeContainer.decode(String.self, forKey: .strIngredient13)
        ing14 = try? recipeContainer.decode(String.self, forKey: .strIngredient14)
        ing15 = try? recipeContainer.decode(String.self, forKey: .strIngredient15)
        ing16 = try? recipeContainer.decode(String.self, forKey: .strIngredient16)
        ing17 = try? recipeContainer.decode(String.self, forKey: .strIngredient17)
        ing18 = try? recipeContainer.decode(String.self, forKey: .strIngredient18)
        ing19 = try? recipeContainer.decode(String.self, forKey: .strIngredient19)
        ing20 = try? recipeContainer.decode(String.self, forKey: .strIngredient20)


        meas4 = try? recipeContainer.decode(String.self, forKey: .strMeasure4)
        meas5 = try? recipeContainer.decode(String.self, forKey: .strMeasure5)
        meas6 = try? recipeContainer.decode(String.self, forKey: .strMeasure6)
        meas7 = try? recipeContainer.decode(String.self, forKey: .strMeasure7)
        meas8 = try? recipeContainer.decode(String.self, forKey: .strMeasure8)
        meas9 = try? recipeContainer.decode(String.self, forKey: .strMeasure9)
        meas10 = try? recipeContainer.decode(String.self, forKey: .strMeasure10)
        meas11 = try? recipeContainer.decode(String.self, forKey: .strMeasure11)
        meas12 = try? recipeContainer.decode(String.self, forKey: .strMeasure12)
        meas13 = try? recipeContainer.decode(String.self, forKey: .strMeasure13)
        meas14 = try? recipeContainer.decode(String.self, forKey: .strMeasure14)
        meas15 = try? recipeContainer.decode(String.self, forKey: .strMeasure15)
        meas16 = try? recipeContainer.decode(String.self, forKey: .strMeasure16)
        meas17 = try? recipeContainer.decode(String.self, forKey: .strMeasure17)
        meas18 = try? recipeContainer.decode(String.self, forKey: .strMeasure18)
        meas19 = try? recipeContainer.decode(String.self, forKey: .strMeasure19)
        meas20 = try? recipeContainer.decode(String.self, forKey: .strMeasure20)
    
        
        self.ingredientsList.append("\(meas1 ?? "") \(ing1 ?? "")")
        self.ingredientsList.append("\(meas2 ?? "") \(ing2 ?? "")")
        self.ingredientsList.append("\(meas3 ?? "") \(ing3 ?? "")")
        self.ingredientsList.append("\(meas4 ?? "") \(ing4 ?? "")")
        self.ingredientsList.append("\(meas5 ?? "") \(ing5 ?? "")")
        self.ingredientsList.append("\(meas6 ?? "") \(ing6 ?? "")")
        self.ingredientsList.append("\(meas7 ?? "") \(ing7 ?? "")")
        self.ingredientsList.append("\(meas8 ?? "") \(ing8 ?? "")")
        self.ingredientsList.append("\(meas9 ?? "") \(ing9 ?? "")")
        self.ingredientsList.append("\(meas10 ?? "") \(ing10 ?? "")")
        self.ingredientsList.append("\(meas11 ?? "") \(ing11 ?? "")")
        self.ingredientsList.append("\(meas12 ?? "") \(ing12 ?? "")")
        self.ingredientsList.append("\(meas13 ?? "") \(ing13 ?? "")")
        self.ingredientsList.append("\(meas14 ?? "") \(ing14 ?? "")")
        self.ingredientsList.append("\(meas15 ?? "") \(ing15 ?? "")")
        self.ingredientsList.append("\(meas16 ?? "") \(ing16 ?? "")")
        self.ingredientsList.append("\(meas17 ?? "") \(ing17 ?? "")")
        self.ingredientsList.append("\(meas18 ?? "") \(ing18 ?? "")")
        self.ingredientsList.append("\(meas19 ?? "") \(ing19 ?? "")")
        self.ingredientsList.append("\(meas20 ?? "") \(ing20 ?? "")")
 
        
    }
    
    
    
    
}
