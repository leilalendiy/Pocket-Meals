//
//  ViewController.swift
//  PocketMeals
//
//  Created by Leila Adaza on 7/24/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: ViewController!
    @IBOutlet weak var recipesTableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    
    var didLikeFood = false
    var favoriteRecipes = [Recipe]()
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        if !didLikeFood {
            let liked = UIImage(named: "Filled Star.png") as UIImage?
            print("\(favoriteRecipes)!!!!!!!")
            sender.setImage(liked, for: .normal)
            sender.isEnabled = false
            didLikeFood = true
            favoriteRecipes.append(recipes[sender.tag])
            print("\(favoriteRecipes)!!!!!!!")
        } else {
            let image = UIImage(named: "Empty Star.png") as UIImage?
            sender.setImage(image, for: .normal)
            didLikeFood = false
            //favoriteRecipes.remove(at: recipes[sender.tag])
        }
    }
    
    var recipes = [Recipe]()
    {
        // didset execute everytime product object value as change
        didSet{
            DispatchQueue.main.async {
                self.recipesTableView.reloadData()
            }
        }
    }

    @IBAction func searchAction(_ sender: UIButton) {
        print("Searching for \(self.searchBar.text!)")
        let searchTerm = searchBar.text!
        self.view.endEditing(true)
        searchRecipes(ingredients: searchTerm)
        recipesTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recipesTableView.delegate = self
        self.recipesTableView.dataSource = self
        
        self.favoriteRecipes = []
        //Dismiss Keyboard
        //self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recipesTableView.reloadData()
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchRecipes(ingredients: String) {
        let link = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/findByIngredients?"
        let param = ["ingredients":ingredients,"fillIngredients":"false","limitLicense":"false","number":"10","ranking":"1"]
    
        let url = URL(string: link)!
        
        let header = ["X-Mashape-Key":"oCOBlDvvkJmsh9RZgPEGTWMrPy23p1Q5jWAjsnXZvAOGuYPJzH","Accept":"application/json"]
        
        Alamofire.request(url, method: .get, parameters: param, headers: header).responseJSON { (response) in
            print(response.description)
            
            guard let value = response.value else { return }
            let json = JSON(value).arrayValue
            
            for eachJson in json {
                let recipe = Recipe(json: eachJson)
                self.recipes.append(recipe)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipesTableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! RecipeTableViewCell
        
        let recipe = recipes[indexPath.row]
        
        cell.recipeTitleLabel.text = recipe.title
        //cell.usedIngredientsLabel.text = String (recipe.usedIngredientCount)
        cell.missingIngredientsLabel.text = "Missing Ingredients: " + String (recipe.missedIngredientCount)
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showRecipe", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let identifier = segue.identifier else { return }
        
        switch identifier {
            
        case "showRecipe":

            guard let indexPath = recipesTableView.indexPathForSelectedRow else { return }
            let recipe = recipes[indexPath.row]
            let destination = segue.destination as! RecipeViewController
            destination.recipe = recipe
            destination.getRecipeInfo(info: recipe.id)
            
        case "showFavorites":
            print("\(favoriteRecipes)!!!!!!!")
            
            if segue.destination is FavoritesViewController {
                let vc =  segue.destination as! FavoritesViewController
                vc.recipes = favoriteRecipes
                print("\(favoriteRecipes)~~~~~~~~~~~~")
            }
            
        default:
            print("unexpected segue identifier")
        }
    }
}

