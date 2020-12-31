//
//  PaymentOptionsViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 02/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class PaymentOptionsViewController: CustomNavigationStyleViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    weak var testDelegate: prTransactionTestDelegate?
    
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
        
        tableView.reloadData()
        //addOptions()
        
        //Do any additional setup after loading the view.
    }


    //MARK :- Add options
    
//    private func addOptions()  {
//        var yPosition: CGFloat = 20
//        let height: CGFloat = 50
//        for index in 1 ... options.count {
//            let button = UIButton(frame: CGRect(x: 20, y: yPosition, width: 200, height: height))
//            yPosition += 30 + height
//            button.tag = index
//            button.setTitle(options[index - 1], for: .normal)
//            button.backgroundColor = .lightGray
//            button.setTitleColor(UIColor.black, for: .normal)
//            button.addTarget(self, action: #selector(self.optionSelected), for: .touchUpInside)
//            containerView.addSubview(button)
//        }
//    }

    
//    @objc func optionSelected(sender : UIButton) {
//
//        let tempCurrentNode:CBaseNode?
//        let tempChildNode:CBaseNode?
//
//        tempCurrentNode = CStateMachine.currentNode?.GotoChild(index: sender.tag)
//        tempChildNode = tempCurrentNode?.GotoChild()
//        TransactionHUB.goToNode(tempChildNode, self.navigationController,testDelegate)
//
//    }
}

//MARK:- TableView Delegate/DataSource
extension PaymentOptionsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tempCurrentNode:CBaseNode?

        tempCurrentNode = CStateMachine.currentNode?.GotoChild(index: indexPath.row + 1)
        TransactionHUB.goToNode(tempCurrentNode, self.navigationController,testDelegate)
    }
}

extension PaymentOptionsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
}
