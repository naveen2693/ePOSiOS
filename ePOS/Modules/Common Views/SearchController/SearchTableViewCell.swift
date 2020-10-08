//
//  SearchTableViewCell.swift
//  ePOS
//
//  Created by Matra Sharma on 03/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: EPOSLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
