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
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var detailsSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var backButton: UIButton!
    
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
        
        FoodServices.getIngredient(id: (recipe?.id)!) { (ingr, nut, ins) in
            self.ingredients = ingr
            self.instructions = ins
            self.nutritionFacts = nut
        }
        
        self.recipeTitleLabel.layer.cornerRadius = 5
        self.recipeTitleLabel.layer.borderWidth = 1
        self.recipeTitleLabel.layer.borderColor = UIColor.clear.cgColor
        
//        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
//        rightSwipe.direction = .right
        
        detailsSegmentedControl.selectedSegmentIndex = 0
    }
    
//    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
//        if sender.state == .ended {
//            if sender.direction == .right {
//                performSegue(withIdentifier: "unwindToFirst", sender: self)
//            } else {
//                return
//            }
//        }
//    }
    
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
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath) as! InfoTableViewCell
        
        switch detailsSegmentedControl.selectedSegmentIndex {
        case 0 :
            if ingredients.isEmpty {
                cell.configure("Sorry, there are no ingredients listed for this recipe as of now.")
            } else {
                cell.configure(ingredients[indexPath.row].original)
            }
            
        case 1 :
            if instructions.isEmpty {
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
