//
//  RecipeTableViewCell.swift
//  PocketMeals
//
//  Created by Leila Adaza on 7/25/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation
import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    //@IBOutlet weak var usedIngredientsLabel: UILabel!
    @IBOutlet weak var missingIngredientsLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
