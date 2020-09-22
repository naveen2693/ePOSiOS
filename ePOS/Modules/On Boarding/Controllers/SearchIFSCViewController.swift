//
//  SearchIFSCViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 20/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class SearchIFSCViewController: UIViewController {
    
    @IBOutlet private weak var textFieldBank: EPOSTextField!
    @IBOutlet private weak var textFieldState: EPOSTextField!
    @IBOutlet private weak var textFieldDistrict: EPOSTextField!
    @IBOutlet private weak var textFieldBranch: EPOSTextField!
    @IBOutlet private weak var nextButton: EPOSRoundButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func nextButtonClicked(_ sender: Any) {
        let controller = IFSCCodeDetailViewController.init(nibName: IFSCCodeDetailViewController.className, bundle: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
