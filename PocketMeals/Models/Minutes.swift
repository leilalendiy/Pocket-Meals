//
//  Minutes.swift
//  PocketMeals
//
//  Created by Leila Adaza on 9/12/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Minutes {
    var readyInMinutes: Int

    init(json:JSON) {
        self.readyInMinutes = json["readyInMinutes"].intValue
    }
}

struct Servings {
    var servings: Int

    init(json:JSON) {
        self.servings = json["servings"].intValue
    }
}

extension Minutes {
    init?(dict: [String: AnyObject]) {
        guard let minutes = dict["readyInMinutes"] as? Int
            else { return nil }
        
        self.readyInMinutes = minutes
    }
}

extension Servings {
    init?(dict: [String: AnyObject]) {
        guard let servings = dict["servings"] as? Int
            else { return nil }
        
        self.servings = servings
    }
}
