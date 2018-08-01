//
//  FavoritesViewController.swift
//  PocketMeals
//
//  Created by Leila Adaza on 7/25/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation
import UIKit

class FavoritesViewController: UITableViewController {
    
    var recipes = [Recipe]()
    var faveRecipe: Recipe?
    
    @IBOutlet var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(recipes)!!!!!!!!")
        
//        if let seedRecipe = Recipe.loadDefaultRecipe() {
//            recipes += seedRecipe
//            //recipes = recipes.sorted(by: { $0.title < $1.title })
//        }
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listFavoriteTableViewCell") as! RecipeTableViewCell
        let recipe = recipes[indexPath.row]
        cell.recipeTitleLabel.text = recipe.title
        
        DispatchQueue.global().async {
            let url = URL(string: recipe.image)
            let data = try! Data(contentsOf: url!)
            let image = UIImage(data: data )!
            
            DispatchQueue.main.async {
                cell.recipeImageView.image = image
            }
        }
        
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
            
        case "showRecipe":
            if let vc = segue.destination as? RecipeViewController {
                vc.recipe = faveRecipe
            }
            
        default:
            print("unexpected segue identifier")
        }
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            self.recipes.remove(at: indexPath.row)
        }
        
        return [delete]
    }
}
