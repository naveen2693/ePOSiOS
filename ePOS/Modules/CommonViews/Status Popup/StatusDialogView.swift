//
//  StatusDialogView.swift
//  ePOS
//
//  Created by Matra Sharma on 14/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit
import SwiftMessages

class StatusDialogView: SwiftMessages {

    @IBOutlet weak var imageIconView: UIImageView?
    @IBOutlet weak var topTitleLabel: UILabel?
    @IBOutlet weak var messageLabel: UILabel?
    @IBOutlet weak var subtextLabel: UILabel?
    @IBOutlet weak var buttonRect: EPOSRectangularButton?
    @IBOutlet weak var buttonRound: EPOSRoundButton?
    
    
    @IBAction func buttonClicked(_ sender: Any) {
    }
    

}
