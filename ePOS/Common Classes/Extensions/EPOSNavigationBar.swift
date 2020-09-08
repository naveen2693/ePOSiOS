//
//  EPOSNavigationBar.swift
//  ePOS
//
//  Created by Matra Sharma on 03/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class EPOSNavigationBar: UINavigationBar {

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 60)
    }

}
