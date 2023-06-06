//
//  RecipeData.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 5/6/2023.
//

import UIKit

class RecipeData: NSObject, Decodable {

    var name: String
    var yields: String?
    var prep_time: Int? //minutes
    var cook_time: Int?  //mminutes
    var ingredients: [String]  //sections
    var recipeDescription: String
    var videoURL: String?

    var instructions: [String]  //display_text

    private enum Rootkeys: String, CodingKey {
        case results
    }

    private enum RecipeKeys: String, CodingKey {
        case name
        case yields
        case prep_time = "prep_time_minutes"
        case cook_time = "cook_time_minutes"
        case ingredients = "sections"
        case recipeDescription = "description"
        case video_url
        case instructions
    }

    private struct ingredientKeys: Decodable {
        var sections: sectionKeys?
    }

    private struct sectionKeys: Decodable {
        var components: componentsKeys
        var name: String?
    }

    private struct componentsKeys: Decodable {
        var raw_text: String
    }

    private struct instructionKeys: Decodable {
        var position: Int
        var display_text: String?
    }


    required init(from decoder: Decoder) throws {

        let rootContainer = try decoder.container(keyedBy: Rootkeys.self)

        let recipeContainer = try rootContainer.nestedContainer(keyedBy: RecipeKeys.self, forKey: .results )

        name = try recipeContainer.decode(String.self, forKey: .name)
        yields = try? recipeContainer.decode(String.self, forKey: .yields)
        prep_time = try? recipeContainer.decode(Int.self, forKey: .prep_time)
        cook_time = try? recipeContainer.decode(Int.self, forKey: .cook_time)
        recipeDescription = try recipeContainer.decode(String.self, forKey: .recipeDescription)

        videoURL = try recipeContainer.decode(String.self, forKey: .video_url)

        instructions = try! recipeContainer.decode([instructionKeys].self, forKey: .instructions) as! [String]
        
        ingredients = try! recipeContainer.decode([componentsKeys].self, forKey: .ingredients) as [String]

    }
}


