//
//  Ingredient.swift
//  PocketMeals
//
//  Created by Leila Adaza on 7/30/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Information {
    let readyInMinutes: Int
    let servings: Int
    
    init(json:JSON) {
        self.readyInMinutes = json["readyInMinutes"].intValue
        self.servings = json["servings"].intValue
    }
}

struct Ingredient {
    let id: Int
    let original: String
    
    init(json:JSON) {
        self.id = json["id"].intValue
        self.original = json["original"].stringValue
    }
}

struct Nutrition {
    let title: String
    let amount: Double
    let unit: String
    let percentOfDailyNeeds: Double
    
    init(json:JSON){
        self.title = json["title"].stringValue
        self.amount = json["amount"].doubleValue
        self.unit = json["unit"].stringValue
        self.percentOfDailyNeeds = json["percentOfDailyNeeds"].doubleValue
    }
}

struct Instruction {
    let number: Int
    let step: String
    
    init(json: JSON) {
        self.number = json["number"].intValue
        self.step = json["step"].stringValue
    }
}
