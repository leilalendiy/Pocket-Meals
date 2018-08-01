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
    
//    static func newNote() -> Note {
//        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
//
//        return note
//    }
    
    static func saveRecipe() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
//    static func deleteNote(note: Note) {
//        context.delete(note)
//
//        saveNote()
//    }
    
//    static func retrieveRecipes() -> [Recipe] {
//        do {
//            let fetchRequest = NSFetchRequest<Recipe>(entityName: "Recipe")
//            let results = try context.fetch(fetchRequest)
//
//            return results.sorted(by: {$0.modificationTime! > $01.modificationTime!})
//        } catch let error {
//            print("Could not fetch \(error.localizedDescription)")
//
//            return []
//        }
//    }
}
