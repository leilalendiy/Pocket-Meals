//
//  DailyMealsViewController.swift
//  PocketMeals
//
//  Created by Leila Adaza on 8/2/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation
import UIKit

class DailyMealsViewController: UIViewController {
    
    var date = Date()
    
    @IBOutlet weak var mealsTableView: UITableView!
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoriteRecipesLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let stringDate = date.toString(dateFormat: "LLLL dd, yyyy")
        
        for meal in meals {
            meal.date = stringDate
        }
        CoreDataHelper.save()
        performSegue(withIdentifier: "saveIntoDate", sender: sender)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        print("Going back to \(date)~")
    }
    
    var recipes = [CoreDataRecipe]() {
        didSet {
            favoritesTableView.reloadData()
        }
    }
    
    var meals = [CoreDataRecipe]() {
        didSet {
            mealsTableView.reloadData()
        }
    }
    
    var temporary = [CoreDataRecipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealsTableView.delegate = self
        mealsTableView.dataSource = self
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        
        favoritesTableView.reloadData()
        mealsTableView.reloadData()
        
        self.saveButton.layer.cornerRadius = 5
        self.saveButton.layer.borderWidth = 1
        self.saveButton.layer.borderColor = UIColor.clear.cgColor
        
        favoritesTableView.tableFooterView = UIView()
        //favoritesTableView.separatorStyle = .none
        mealsTableView.tableFooterView = UIView()
        //mealsTableView.separatorStyle = .none

        dateLabel.text = date.toString(dateFormat: "LLLL dd, yyyy")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        recipes = CoreDataHelper.retrieveRecipes()
        
        let stringDate = date.toString(dateFormat: "LLLL dd, yyyy")
        meals = CoreDataHelper.retrieveByDate(date: stringDate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let identifier = segue.identifier else { return }

        switch identifier {

        case "saveIntoDate":
            if segue.destination is CalendarViewController {
                let vc =  segue.destination as! CalendarViewController
                vc.date = date
                vc.calendar.addEvent("Daily Meals", date: date, duration: 12)
            }

        default:
            print("unexpected segue identifier")
        }
    }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }
}

extension DailyMealsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == favoritesTableView {
            temporary = recipes
            let thisRecipe = temporary[indexPath.row]
            meals.append(thisRecipe)
            temporary.remove(at: indexPath.row)
            recipes = temporary
            mealsTableView.reloadData()
            favoritesTableView.reloadData()
        } else {
            temporary = meals
            let thisRecipe = temporary[indexPath.row]
            recipes.append(thisRecipe)
            temporary.remove(at: indexPath.row)
            meals = temporary
            mealsTableView.reloadData()
            favoritesTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == favoritesTableView {
            return recipes.count
        } else if tableView == mealsTableView {
            return meals.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell") as! FavoriteTableViewCell
        
        if tableView == favoritesTableView {
            let recipe = recipes[indexPath.row]
            cell.recipeLabel.text = recipe.title
            
            DispatchQueue.global().async {
                let url = URL(string: recipe.imageURL!)
                let data = try! Data(contentsOf: url!)
                let image = UIImage(data: data)!
                
                DispatchQueue.main.async {
                    cell.recipeImage.image = image
                    cell.recipeImage.layer.borderWidth = 0.25
                    cell.recipeImage.layer.borderColor = UIColor.darkGray.cgColor
                    cell.recipeImage.layer.masksToBounds = false
                    cell.recipeImage.layer.cornerRadius = cell.recipeImage.frame.height/2
                    cell.recipeImage.clipsToBounds = true
                }
            }
        } else if tableView == mealsTableView {
            let recipe = meals[indexPath.row]
            cell.recipeLabel.text = recipe.title
            
            DispatchQueue.global().async {
                let url = URL(string: recipe.imageURL!)
                let data = try! Data(contentsOf: url!)
                let image = UIImage(data: data)!
                
                DispatchQueue.main.async {
                    cell.recipeImage.image = image
                    cell.recipeImage.layer.borderWidth = 0.25
                    cell.recipeImage.layer.borderColor = UIColor.darkGray.cgColor
                    cell.recipeImage.layer.masksToBounds = false
                    cell.recipeImage.layer.cornerRadius = cell.recipeImage.frame.height/2
                    cell.recipeImage.clipsToBounds = true
                }
            }
            return cell
        }
        
        return cell
    }
}
