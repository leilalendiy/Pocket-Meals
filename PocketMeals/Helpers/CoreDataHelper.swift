//
//  CoreDataHelper.swift
//  PocketMeals
//
//  Created by Leila Adaza on 8/1/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct CoreDataHelper {
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    static func newRecipe() -> CoreDataRecipe {
        let recipe = NSEntityDescription.insertNewObject(forEntityName: "CoreDataRecipe", into: context) as! CoreDataRecipe

        return recipe
    }
    
    static func newIngredient() -> CoreDataIngredient {
        let ingredient = NSEntityDescription.insertNewObject(forEntityName: "CoreDataIngredient", into: context) as! CoreDataIngredient
        
        return ingredient
    }
    
    static func newNutrition() -> CoreDataNutrition {
        let nutrition = NSEntityDescription.insertNewObject(forEntityName: "CoreDataNutrition", into: context) as! CoreDataNutrition
        
        return nutrition
    }
    
    static func newInstruction() -> CoreDataInstruction {
        let instruction = NSEntityDescription.insertNewObject(forEntityName: "CoreDataInstruction", into: context) as! CoreDataInstruction
        
        return instruction
    }
    
    static func save() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func delete(Recipe: CoreDataRecipe) {
        context.delete(Recipe)

        save()
    }
    
    static func retrieveRecipes() -> [CoreDataRecipe] {
        do {
            let fetchRequest = NSFetchRequest<CoreDataRecipe>(entityName: "CoreDataRecipe")
            let results = try context.fetch(fetchRequest)
            
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")

            return []
        }
    }
    
    static func retrieveByDate(date: String) -> [CoreDataRecipe] {
        do {
            let fetchRequest = NSFetchRequest<CoreDataRecipe>(entityName: "CoreDataRecipe")
            fetchRequest.predicate = NSPredicate(format: "date = %@", date)
            
            let results = try context.fetch(fetchRequest)
            
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            
            return []
        }
    }
}
