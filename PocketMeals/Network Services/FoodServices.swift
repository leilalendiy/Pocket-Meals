//
//  FoodServices.swift
//  PocketMeals
//
//  Created by Leila Adaza on 7/30/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct FoodServices {
    
    static func getIngredient(id: Int, completion: @escaping ([Ingredient], [Nutrition], [Instruction]) -> Void){
        
        let link = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/\(id)/information"
        
        let param = ["id":id,"includeNutrition":"true"] as [String : Any]
        
        let url = URL(string: link)!
        
        let header = ["X-Mashape-Key":"oCOBlDvvkJmsh9RZgPEGTWMrPy23p1Q5jWAjsnXZvAOGuYPJzH","Accept":"application/json"]
        
        Alamofire.request(url, method: .get, parameters: param, headers: header).responseJSON { (response) in
            print(response.description)
            
            guard let value = response.value else { return }
            let json = JSON(value)
            
            let ingredientsJson = json["extendedIngredients"].arrayValue
            var ingredients = [Ingredient]()
            for eachIngredient in ingredientsJson {
                let ing = Ingredient(json: eachIngredient)
                ingredients.append(ing)
            }
            
            let nutrientsJson = json["nutrition"]["nutrients"].arrayValue
            var nutrients = [Nutrition]()
            for eachNutrient in nutrientsJson {
                let nut = Nutrition(json: eachNutrient)
                nutrients.append(nut)
            }
            
            let instructionsJson = json["analyzedInstructions"][0]["steps"].arrayValue
            var instructions = [Instruction]()
            for eachInstruction in instructionsJson {
                let ins = Instruction(json: eachInstruction)
                instructions.append(ins)
            }
            
            completion(ingredients, nutrients, instructions)
        }
    }
}
