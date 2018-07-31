//
//  Recipe.swift
//  PocketMeals
//
//  Created by Leila Adaza on 7/25/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Recipe {
    let id: Int
    let title: String
    let image: String
    let usedIngredientCount: Int
    let missedIngredientCount: Int
    var ingredients: [Ingredient]?
    var instructions: [Instruction]?
    var nutrition: [Nutrition]?
    
    init(json:JSON) {
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.image = json["image"].stringValue
        self.usedIngredientCount = json["usedIngredientCount"].intValue
        self.missedIngredientCount = json["missedIngredientCount"].intValue
       
    }
}

extension Recipe {
    init?(dict: [String: AnyObject]) {
        guard let id = dict["id"] as? Int,
            let title = dict["title"] as? String,
            let image = dict["image"] as? String,
            let usedIngredientCount = dict["usedIngredientCount"] as? Int,
            let missedIngredientCount = dict["missedIngredientCount"] as? Int
            else { return nil }
        
        
        self.id = id
        self.title = title
        self.image = image
        self.usedIngredientCount = usedIngredientCount
        self.missedIngredientCount = missedIngredientCount
        self.ingredients = [Ingredient]()
    }
}

// MARK: - Load Sample Data

extension Recipe {
    static func loadDefaultRecipe() -> [Recipe]? {
        return self.loadRecipeFrom("RecipeList")
    }
    
    static func loadRecipeFrom(_ plistName: String) -> [Recipe]? {
        guard let path = Bundle.main.path(forResource: plistName, ofType: "plist"),
            let array = NSArray(contentsOfFile: path) as? [[String: AnyObject]] else {
                return nil
        }
        
        return array.map { Recipe(dict: $0) }
            .filter { $0 != nil }
            .map { $0! }
    }
}
