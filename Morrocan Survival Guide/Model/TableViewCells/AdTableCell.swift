//
//  AdTableCell.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 1/11/18.
//  Copyright © 2018 Jonathon Vega. All rights reserved.
//

import UIKit

class AdTableCell: UITableViewCell {
    
    @IBOutlet weak var sponsoredLabel: UILabel!
    @IBOutlet weak var adIconImageView: UIImageView!
    @IBOutlet weak var adTitleLabel: UILabel!
    @IBOutlet weak var adBodyLabel: UILabel!
    @IBOutlet weak var adCallToActionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
