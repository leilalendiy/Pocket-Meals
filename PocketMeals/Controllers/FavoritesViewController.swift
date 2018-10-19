//
//  FavoritesViewController.swift
//  PocketMeals
//
//  Created by Leila Adaza on 7/25/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation
import UIKit
import TableFlip

class FavoritesViewController: UITableViewController {
    
    var recipes = [CoreDataRecipe]() {
        didSet {
            favoritesTableView.reloadData()
            self.favoritesTableView.animate(animation: TableViewAnimation.Cell.left(duration: 0.5))
        }
    }
    var faveRecipe: Recipe?
    
    @IBOutlet var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        // remove separators for empty cells
        favoritesTableView.tableFooterView = UIView()
        // remove separators from cells
        favoritesTableView.separatorStyle = .none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 1
        if recipes.count > 0 {
            favoritesTableView.backgroundView = nil
        } else {
            numOfSections = 0
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: favoritesTableView.bounds.size.width * 0.10, height: favoritesTableView.bounds.size.height))
            noDataLabel.text = "Your favorites list is empty. Please favorite some recipes so you can view them here."
            noDataLabel.font = UIFont(name: "Georgia", size: 17)
            noDataLabel.textColor = UIColor.darkGray
            noDataLabel.textAlignment = .center
            noDataLabel.numberOfLines = 0
            favoritesTableView.backgroundView  = noDataLabel
        }
        
        return numOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell") as! FavoriteTableViewCell
        let recipe = recipes[indexPath.row]
        faveRecipe?.id = Int(recipe.id)
        cell.recipeLabel.text = recipe.title
        
        DispatchQueue.global().async {
            if let url = URL(string: recipe.imageURL ?? "No image found") {
                let data = try! Data(contentsOf: url)
                let image = UIImage(data: data)!
                
                DispatchQueue.main.async {
                    cell.recipeImage.image = image
                    cell.recipeImage.layer.borderWidth = 0.25
                    cell.recipeImage.layer.borderColor = UIColor.darkGray.cgColor
                    cell.recipeImage.layer.masksToBounds = false
                    cell.recipeImage.layer.cornerRadius = cell.recipeImage.frame.height/2
                    cell.recipeImage.clipsToBounds = true
                }
            } else { return }
        }
        
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        recipes = CoreDataHelper.retrieveRecipes()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showRecipe", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
            
        case "showRecipe":
            guard let indexPath = favoritesTableView.indexPathForSelectedRow else { return }
            let recipe = recipes[indexPath.row]
            let destination = segue.destination as! FavoriteRecipeViewController
            destination.recipe = recipe
            destination.getRecipeInfo(info: Int(recipe.id))
            
        default:
            print("unexpected segue identifier")
        }
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let recipe = self.recipes[indexPath.row]
            CoreDataHelper.delete(Recipe: recipe)
            self.recipes.remove(at: indexPath.row)
            self.favoritesTableView.reloadData()
        }
        
        return [delete]
    }
    
    
}
