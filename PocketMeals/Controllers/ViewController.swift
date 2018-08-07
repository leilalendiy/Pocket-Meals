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
import hkMotus

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    weak var delegate: ViewController!
    @IBOutlet weak var recipesTableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var didLikeFood = false
    var favorite = Bool()
    var favoriteRecipes = [Recipe]()
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        if !didLikeFood {
            let liked = UIImage(named: "Filled Star.png") as UIImage?
            sender.setImage(liked, for: .normal)
            sender.isEnabled = false
            didLikeFood = true
        } else {
            let image = UIImage(named: "Empty Star.png") as UIImage?
            sender.setImage(image, for: .normal)
            sender.isEnabled = true
            didLikeFood = false
        }
    }
    
    var recipes = [Recipe]()
    {
        // didset execute everytime product object value as change
        didSet{
            DispatchQueue.main.async {
                self.recipesTableView.reloadData(effect: .roll)
            }
        }
    }

    @IBAction func searchAction(_ sender: UIButton) {
        recipes = []
        print("Searching for \(self.searchBar.text!)")
        let searchTerm = searchBar.text!
        self.view.endEditing(true)
        searchRecipes(ingredients: searchTerm)
        recipesTableView.reloadData(effect: .roll)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.searchBar.delegate = self
        self.recipesTableView.delegate = self
        self.recipesTableView.dataSource = self
        
        self.searchButton.layer.cornerRadius = 5
        self.searchButton.layer.borderWidth = 1
        self.searchButton.layer.borderColor = UIColor.clear.cgColor
        
        self.favoriteRecipes = []
        //Dismiss Keyboard
        //self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        // remove separators for empty cells
        recipesTableView.tableFooterView = UIView()
        // remove separators from cells
        recipesTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recipesTableView.reloadData()
        self.navigationController?.isNavigationBarHidden = true
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 1
        if recipes.count > 0 {
            recipesTableView.backgroundView = nil
        } else {
            numOfSections = 0
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: recipesTableView.bounds.size.width * 0.10, height: recipesTableView.bounds.size.height))
            noDataLabel.text = "Your recipe list is empty. Please add some ingredients so you can view recipes here."
            noDataLabel.font = UIFont(name: "Georgia", size: 17)
            noDataLabel.textColor = UIColor.darkGray
            noDataLabel.textAlignment = .center
            noDataLabel.numberOfLines = 0
            recipesTableView.backgroundView  = noDataLabel
        }
        
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipesTableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! RecipeTableViewCell
        
        let recipe = recipes[indexPath.row]
        cell.recipe = recipe
        cell.recipeTitleLabel.text = recipe.title
        //cell.usedIngredientsLabel.text = String (recipe.usedIngredientCount)
        cell.missingIngredientsLabel.text = "Missing Ingredients: " + String (recipe.missedIngredientCount)
        
        DispatchQueue.global().async {
            let url = URL(string: recipe.image)
            let data = try! Data(contentsOf: url!)
            let image = UIImage(data: data)!
            
            DispatchQueue.main.async {
                cell.recipeImageView.image = image
                cell.recipeImageView.layer.borderWidth = 0.25
                cell.recipeImageView.layer.borderColor = UIColor.darkGray.cgColor
                cell.recipeImageView.layer.masksToBounds = false
                cell.recipeImageView.layer.cornerRadius = cell.recipeImageView.frame.height/2
                cell.recipeImageView.clipsToBounds = true
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
            destination.favorite = didLikeFood
            destination.getRecipeInfo(info: recipe.id)
            
        case "showFavorites":
            if segue.destination is FavoritesViewController {
                let _ =  segue.destination as! FavoritesViewController
            }
            
        default:
            print("unexpected segue identifier")
        }
    }
    
    @IBAction func unwindToFirst(_ segue: UIStoryboardSegue) {
        
    }
}
