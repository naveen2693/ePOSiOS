//
//  EmptyDataViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 15/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

protocol EmptyDataControllerDelegate: class {
    func actionButtonClicked(_ controller: EmptyDataViewController, for itemType: EmptyViewItemProtocol)
}

class EmptyDataViewController: UIViewController {
    
    @IBOutlet private weak var imageIconView: UIImageView?
    @IBOutlet private weak var bottomButton: EPOSRectangularButton?
    @IBOutlet private weak var messageLabel: EPOSLabel?
    @IBOutlet private weak var topTitleLabel: EPOSLabel?
    
    private var emptyDataItem: EmptyViewItemProtocol!
    private weak var delegate: EmptyDataControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }

    //MARK: get class object
    class func viewController(_ emptyItem: EmptyViewItemProtocol, delegate: EmptyDataControllerDelegate?) -> EmptyDataViewController {
        
        let controller = EmptyDataViewController.init(nibName: EmptyDataViewController.className, bundle: nil)
        controller.emptyDataItem = emptyItem
        controller.delegate = delegate
        return controller
    }

    //MARK: configureUI
    private func configureUI() {
        topTitleLabel?.text = emptyDataItem.title
        messageLabel?.text = emptyDataItem.message
        bottomButton?.isHidden = emptyDataItem.isButtonHidden
        imageIconView?.image = UIImage(named: emptyDataItem.imageName)
        bottomButton?.setTitle(emptyDataItem.buttonTitle, for: .normal)
    }
    
    // MARK: - Action
    
    @IBAction func buttonClicked(_ sender: Any) {
        guard let delegate = delegate else {
            return
        }
        delegate.actionButtonClicked(self, for: emptyDataItem)
    }
    
}
