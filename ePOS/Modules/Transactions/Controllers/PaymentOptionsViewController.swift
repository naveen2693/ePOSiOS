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
    
    //private var menuNode:CDisplayMenu?
    private var menuName:String?
    
    //var options = ["Option 1", "Option 2", "Option 3", "Option 4"]
    var options = [String]()
    private var numberOfChild:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Select Option"
      
        //Get CurrentNode.Number of child
        //guard var menuNode = CStateMachine.currentNode as? CDisplayMenu else {return}
        guard let menuNode = CStateMachine.currentNode as? CDisplayMenu else {return}
        menuName =  menuNode.iName
        if(menuName == nil){
            menuName = "Menu"
        }
        numberOfChild = menuNode.numberOfChild
        var tempNode:CBaseNode?
        
        for i in 1...numberOfChild {
            tempNode = menuNode.GotoChild(index: i)
            options.append((tempNode?.getName())!)
        }
        addOptions()
        
        //Do any additional setup after loading the view.
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
        
        let tempCurrentNode:CBaseNode?
        let tempChildNode:CBaseNode?
        
        tempCurrentNode = CStateMachine.currentNode?.GotoChild(index: sender.tag)
        tempChildNode = tempCurrentNode?.GotoChild()
        
        if (tempChildNode?.node_type == PvmNodeTypes.Amount_entry_node)
        {
        let controller = EnterAmountViewController.init(nibName: EnterAmountViewController.className, bundle: nil)
            
        controller.testDelegate = testDelegate
        CStateMachine.currentNode = tempChildNode
        
        self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
