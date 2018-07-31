//
//  RecipeViewController.swift
//  PocketMeals
//
//  Created by Leila Adaza on 7/26/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class RecipeViewController: UIViewController {
    
    var recipe: Recipe?
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var recipeTitleLabel: UITextField!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var detailsSegmentedControl: UISegmentedControl!
    
    var instructionViewModel: InstructionModel!
    
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
    
    @IBAction func favoriteTapped(_ sender: UIButton) {
        if !favorite {
            let liked = UIImage(named: "Filled Star.png") as UIImage?
            sender.setImage(liked, for: .normal)
            favorite = true
        } else {
            let image = UIImage(named: "Empty Star.png") as UIImage?
            sender.setImage(image, for: .normal)
            favorite = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailsTableView.delegate = self
        self.detailsTableView.dataSource = self
        
        FoodServices.getIngredient(id: (recipe?.id)!) { (ingr, nut, ins) in
            self.ingredients = ingr
            self.instructions = ins
            self.nutritionFacts = nut
        }
        
        detailsSegmentedControl.selectedSegmentIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.recipeTitleLabel.text = recipe?.title

        guard let url = URL(string: (recipe?.image)!) else {
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
        let link = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/\(info)/information"
        
        let param = ["id":info,"includeNutrition":"true"] as [String : Any]
        
        let url = URL(string: link)!
        
        let header = ["X-Mashape-Key":"oCOBlDvvkJmsh9RZgPEGTWMrPy23p1Q5jWAjsnXZvAOGuYPJzH","Accept":"application/json"]
        
        Alamofire.request(url, method: .get, parameters: param, headers: header).responseJSON { (response) in
            print(response.description)
            
            guard let value = response.value else { return }
            let json = JSON(value).arrayValue
            
            for eachJson in json {
                let recipe = Recipe(json: eachJson)
                
                self.recipeTitleLabel.text = recipe.title
                self.ingredients = recipe.ingredients!
                self.instructions = recipe.instructions!
                self.nutritionFacts = recipe.nutrition!
            }
        }
    }
}

extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch detailsSegmentedControl.selectedSegmentIndex {
        case 0 :
            return ingredients.count
        case 1 :
            return instructions.count
        case 2 :
            return nutritionFacts.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath) as! InfoTableViewCell
        
        switch detailsSegmentedControl.selectedSegmentIndex {
        case 0 :
            cell.configure(ingredients[indexPath.row].original)
            
        case 1 :
            cell.configure("\(indexPath.row + 1). \(instructions[indexPath.row].step)")
            
        case 2 :
            cell.configure("\(nutritionFacts[indexPath.row].title) : \(nutritionFacts[indexPath.row].amount) \(nutritionFacts[indexPath.row].unit)")
            
        default:
            cell.descriptionLabel.text = ""
        }
        
        return cell
    }
}
