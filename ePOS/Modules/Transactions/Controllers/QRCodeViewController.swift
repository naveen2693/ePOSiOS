//
//  QRCodeViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 30/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    
    var timeout = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeout), userInfo: nil, repeats: true)
        imageView.image = Util.generateQRCode(from: "")
        // Do any additional setup after loading the view.
    }


    @objc func updateTimeout() {
        //example functionality
        if timeout > 0 {
            timerLabel.text = "\(timeout)"
            timeout -= 1
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
