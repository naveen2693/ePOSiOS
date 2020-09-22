//
//  PackageDetailTableViewCell.swift
//  ePOS
//
//  Created by Matra Sharma on 22/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class PackageDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var labelFeature: EPOSLabel!
    @IBOutlet weak var labelFeatureDetail: EPOSLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
