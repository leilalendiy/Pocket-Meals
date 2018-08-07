//
//  RecipeTableViewCell.swift
//  PocketMeals
//
//  Created by Leila Adaza on 7/25/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation
import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    var recipe: Recipe?
    var ingredients = [Ingredient]()
    var instructions = [Instruction]()
    var nutrition = [Nutrition]()
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    //@IBOutlet weak var usedIngredientsLabel: UILabel!
    @IBOutlet weak var missingIngredientsLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let newCoreDataRecipe = CoreDataHelper.newRecipe()
        newCoreDataRecipe.id = Int32(recipe!.id)
        newCoreDataRecipe.imageURL = recipe?.image
        newCoreDataRecipe.missedIngredientCount = Int32(recipe!.missedIngredientCount)
        newCoreDataRecipe.title = recipe!.title
        newCoreDataRecipe.usedIngredientCount = Int32(recipe!.usedIngredientCount)
        
        FoodServices.getIngredient(id: (recipe?.id)!) { (ingr, nut, ins) in
            self.recipe?.ingredients = ingr
            self.recipe?.nutrition = nut
            self.recipe?.instructions = ins
            
            let newCoreDataIngredient = CoreDataHelper.newIngredient()
            newCoreDataIngredient.recipe = newCoreDataRecipe
            newCoreDataRecipe.ingredients = newCoreDataIngredient
            
            let newCoreDataNutrition = CoreDataHelper.newNutrition()
            newCoreDataNutrition.recipe = newCoreDataRecipe
            newCoreDataRecipe.nutritions = newCoreDataNutrition
            
            let newCoreDataInstruction = CoreDataHelper.newInstruction()
            newCoreDataInstruction.recipe = newCoreDataRecipe
            newCoreDataRecipe.instructions = newCoreDataInstruction
            
            CoreDataHelper.save()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
