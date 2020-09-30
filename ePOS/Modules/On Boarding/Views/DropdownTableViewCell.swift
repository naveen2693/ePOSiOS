//
//  DropdownTableViewCell.swift
//  ePOS
//
//  Created by Matra Sharma on 29/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class DropdownTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: EPOSLabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
