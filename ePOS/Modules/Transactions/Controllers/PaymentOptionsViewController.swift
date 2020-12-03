//
//  PaymentOptionsViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 02/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class PaymentOptionsViewController: CustomNavigationStyleViewController {
    
    weak var testDelegate: prTransactionTestDelegate?
    
    @IBOutlet weak var containerView: UIView!
    
    var options = ["Option 1", "Option 2", "Option 3", "Option 4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Select Option"
        addOptions()
        // Do any additional setup after loading the view.
    }


    //MARK :- Add options
    
    private func addOptions()  {
        var yPosition: CGFloat = 20
        let height: CGFloat = 50
        for index in 1 ... options.count {
            let button = UIButton(frame: CGRect(x: 20, y: yPosition, width: 200, height: height))
            yPosition += 30 + height
            button.tag = index
            button.setTitle(options[index - 1], for: .normal)
            button.backgroundColor = .lightGray
            button.setTitleColor(UIColor.black, for: .normal)
            button.addTarget(self, action: #selector(self.optionSelected), for: .touchUpInside)
            containerView.addSubview(button)
        }
    }

    
    @objc func optionSelected(sender : UIButton) {
        let controller = EnterAmountViewController.init(nibName: EnterAmountViewController.className, bundle: nil)
        
        controller.transactionDelegate = testDelegate
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
