//
//  FaveInfoTableViewCell.swift
//  PocketMeals
//
//  Created by Leila Adaza on 8/1/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation
import UIKit

class FaveInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure(_ description: String) {
        descriptionLabel.text = description
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
