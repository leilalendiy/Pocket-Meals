//
//  FavoriteRecipeViewController.swift
//  PocketMeals
//
//  Created by Leila Adaza on 8/1/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class FavoriteRecipeViewController: UIViewController {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var detailsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var detailsTableView: UITableView!
    
    var recipe: CoreDataRecipe?
    var favorite = false
    var ingredients: [Ingredient] = [] {
        didSet {
            DispatchQueue.main.async {
                self.detailsTableView.reloadData()
            }
        }
    }
    
    var instructions: [Instruction] = [] {
        didSet {
            DispatchQueue.main.async {
                self.detailsTableView.reloadData()
            }
        }
    }
    
    var nutritionFacts: [Nutrition] = [] {
        didSet {
            DispatchQueue.main.async {
                self.detailsTableView.reloadData()
            }
        }
    }
    
    @IBAction func detailsSegmentedControl(_ sender: UISegmentedControl) {
        detailsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailsTableView.delegate = self
        self.detailsTableView.dataSource = self
        
        FoodServices.getIngredient(id: Int((recipe?.id)!)) { (ingr, nut, ins) in
            self.ingredients = ingr
            self.instructions = ins
            self.nutritionFacts = nut
            
            self.detailsTableView.reloadData()
        }
        
        self.recipeTitleLabel.layer.cornerRadius = 5
        self.recipeTitleLabel.layer.borderWidth = 1
        self.recipeTitleLabel.layer.borderColor = UIColor.clear.cgColor
        
        detailsSegmentedControl.selectedSegmentIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.recipeTitleLabel.text = recipe?.title
        
        guard let url = URL(string: (recipe?.imageURL)!) else {
            return assertionFailure("Image URL failed")
        }
        
        let data = try! Data(contentsOf: url)
        let recipeImage = UIImage(data: data)!
        
        self.recipeImageView.image = recipeImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRecipeInfo(info: Int) {
        let newCoreDataIngredient = CoreDataHelper.newIngredient()
        newCoreDataIngredient.recipe = recipe
        recipe?.ingredients = newCoreDataIngredient
        
        let newCoreDataNutrition = CoreDataHelper.newNutrition()
        newCoreDataNutrition.recipe = recipe
        recipe?.nutritions = newCoreDataNutrition
        
        let newCoreDataInstruction = CoreDataHelper.newInstruction()
        newCoreDataInstruction.recipe = recipe
        recipe?.instructions = newCoreDataInstruction
        
        CoreDataHelper.save()
    }
}

extension FavoriteRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch detailsSegmentedControl.selectedSegmentIndex {
        case 0 :
            return ingredients.count
        case 1 :
            return instructions.count
        case 2 :
            return nutritionFacts.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! FaveInfoTableViewCell
        
        switch detailsSegmentedControl.selectedSegmentIndex {
        case 0 :
            if ingredients.count == 0 {
                cell.configure("Sorry, there are no ingredients listed for this recipe as of now.")
            } else {
                cell.configure(ingredients[indexPath.row].original)
            }
            
        case 1 :
            if instructions.count == 0 {
                cell.configure("Sorry, there are no instructions listed for this recipe as of now.")
            } else {
                cell.configure("\(indexPath.row + 1). \(instructions[indexPath.row].step)")
            }
            
        case 2 :
            cell.configure("\(nutritionFacts[indexPath.row].title): \(nutritionFacts[indexPath.row].amount) \(nutritionFacts[indexPath.row].unit) \nDaily Percentage: \(nutritionFacts[indexPath.row].percentOfDailyNeeds)%")
            
        default:
            cell.descriptionLabel.text = "No results found."
        }
        
        return cell
    }
}
