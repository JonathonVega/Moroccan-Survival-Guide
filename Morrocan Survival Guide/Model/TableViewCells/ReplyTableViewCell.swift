//
//  ReplyTableViewCell.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 12/15/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit

class ReplyTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createDate: UILabel!
    @IBOutlet weak var responseLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
