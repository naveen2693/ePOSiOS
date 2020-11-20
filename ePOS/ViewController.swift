//
//  ViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 03/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var name: String?
    
    @IBOutlet weak var buttonRect: EPOSRectangularButton!
    @IBOutlet weak var buttonRound: EPOSRoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
        
        
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func crashButtonTapped(_ sender: AnyObject) {
//        fatalError()
        buttonRect.isEnabled = true
        buttonRound.isEnabled = true
    }
    
    @IBAction func rectClicked(_ sender: EPOSRectangularButton) {
        sender.isEnabled = !sender.isEnabled
    }
    
    
    @IBAction func roundClicked(_ sender: EPOSRoundButton) {
//        sender.isEnabled = !sender.isEnabled
        appDelegate.showHomeScreen()
    }
    
    
}
