//
//  InstructionModel.swift
//  PocketMeals
//
//  Created by Leila Adaza on 7/31/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation

enum RecipeInstructionType {
    case ingredients, instructions, nutritionFacts
}

struct InstructionModel {
    let recipe: Recipe?
    var type: RecipeInstructionType
    var ingredientsState = [Bool]()
    var instructionsState = [Bool]()
    var nutritionState = [Bool]()
    
    init(recipe: Recipe, type: RecipeInstructionType) {
        self.recipe = recipe
        self.type = type
        
        if let ingredients = recipe.ingredients {
            ingredientsState = [Bool](repeating: false, count:ingredients.count)
        }
        
        if let instructions = recipe.instructions {
            instructionsState = [Bool](repeating: false, count:instructions.count)
        }
        
        if let nutrition = recipe.nutrition {
            instructionsState = [Bool](repeating: false, count: nutrition.count)
        }
    }
    
    mutating func numberOfItems() -> Int {
        
        switch type {
        case .ingredients:
            if let ingredients = recipe?.ingredients {
                return ingredients.count
            }
        case .instructions:
            if let instructions = recipe?.instructions {
                return instructions.count
            }
        case .nutritionFacts:
            if let nutrition = recipe?.nutrition {
                return nutrition.count
            }
        }
    
        return 0
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func itemFor(_ index: Int) -> String? {
        switch type {
        case .ingredients:
            if let ingredients = recipe?.ingredients {
                return ingredients[index].original
            }
        case .instructions:
            if let instructions = recipe?.instructions {
                return instructions[index].step
            }
        case .nutritionFacts:
            if let nutrition = recipe?.nutrition {
                return ("\(nutrition[index].title) : \(nutrition[index].amount) \(nutrition[index].unit)")
            }
        }
        return nil
    }
    
    func getStateFor(_ index: Int) -> Bool {
        switch type {
        case .ingredients:
            return ingredientsState[index]
        case .instructions:
            return instructionsState[index]
        case .nutritionFacts:
            return nutritionState[index]
        }
    }
    
    mutating func selectItemFor(_ index: Int) {
        switch type {
        case .ingredients:
            let previousState = ingredientsState[index]
            ingredientsState[index] = !previousState
        case .instructions:
            let previousState = instructionsState[index]
            instructionsState[index] = !previousState
        case .nutritionFacts:
            let previousState = nutritionState[index]
            nutritionState[index] = !previousState
        }
    }
}
