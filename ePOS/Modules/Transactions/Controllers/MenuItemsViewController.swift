//
//  MenuItemsViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 31/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class MenuItemsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    weak var testDelegate: prTransactionTestDelegate?
    
    //private var menuNode:CDisplayMenu?
    private var menuListName:String?
    private var menuListTitle:String?
    
    private var menuItemList: [ITEMVAL]?
    
    //var options = ["Option 1", "Option 2", "Option 3", "Option 4"]
    var options = [String]()
    private var numberOfItemsInMenuList:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Select Option"
        
        //Get CurrentNode.Number of child
        guard let menuList = CStateMachine.currentNode as? CDisplayMenuList else {return}
        menuListName =  menuList.iName

        if menuList.ItemList != nil
        {
            menuItemList = menuList.ItemList
            numberOfItemsInMenuList = menuItemList!.count
            
            if menuItemList!.count > 0{
                for i in 0 ..< numberOfItemsInMenuList {
                    options.append(menuItemList![i].ItemName + menuItemList![i].ItemVal)
                }
            }
        }
        
        tableView.reloadData()
    }
}


//MARK:- TableView Delegate/DataSource
extension MenuItemsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
        let iTag = CStateMachine.currentNode?.HostTlvtag
        let bArrTagData = [Byte](menuItemList![indexPath.row].ItemVal.utf8)
        TransactionHUB.AddTLVDataWithTag(uiTag: iTag!, Data: bArrTagData, length: bArrTagData.count)
        
        let tempCurrentNode:CBaseNode?
        
        tempCurrentNode = CStateMachine.currentNode?.GotoChild()
        TransactionHUB.goToNode(tempCurrentNode, self.navigationController,testDelegate)
    }
}

extension MenuItemsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
}
