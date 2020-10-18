//
//  CustomSearchViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 03/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit


enum SearchType {
    case state
    case city
    case ifscSearch(SearchIFSCType)
    case searchStateData(SearchStateData)
    
    func title() -> String {
        switch self {
        case .state:
            return "Merchant State"
        case .city:
            return "Merchant City"
        case .ifscSearch(.bankName):
            return "Search by Bank Name"
        case .ifscSearch(.state):
            return "Search by State Name"
        case .ifscSearch(.district):
            return "Search by District Name"
        case .ifscSearch(.branch):
            return "Search by Branch Name"
        case .ifscSearch(.ifscCode):
            return ""
        case .searchStateData(.state):
            return ""
        case .searchStateData(.city):
            return ""
            
        }
    }
    
//    func searchPlaceholder() -> String {
////        return "Search by Merchant \(self.rawValue)"
//    }
}

protocol SearchControllerDelegate: class {
    func didSelectedItem(_ controller: CustomSearchViewController, item: String, at index: Int, for type: SearchType)
}

class CustomSearchViewController: CustomNavigationStyleViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar?
    
    private weak var delegate:SearchControllerDelegate?

    private var allData = [String]()
    private var searchType: SearchType!
    var filteredData = [String]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = searchType.title()
        registerCell()
        self.tableView.tableFooterView = UIView()
        filteredData = allData
        searchBar?.changeSearchBarColor(color: .white)
        if #available(iOS 13.0, *) {
            searchBar?.searchTextField.attributedPlaceholder = NSAttributedString(string: searchType.title(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.subTextColor()])
        } else {
            // Fallback on earlier versions
        }
    }
    

    class func viewController(type : SearchType, data: [String], delegate: SearchControllerDelegate?) -> CustomSearchViewController {
        let controller = CustomSearchViewController.init(nibName: CustomSearchViewController.className, bundle: nil)
        controller.delegate = delegate
        controller.searchType = type
        controller.allData = data
        return controller
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: SearchTableViewCell.className, bundle: nil), forCellReuseIdentifier: SearchTableViewCell.className)
    }
    
        
    func filterRowsForSearchedText(_ searchText: String) {
        filteredData = allData.filter({( model : String) -> Bool in
            return model.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }

}

extension CustomSearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.className, for: indexPath) as? SearchTableViewCell else {
            fatalError("DropdownTableViewCell not found for identifier DropdownTableViewCell")
        }
                
                let value = filteredData[indexPath.row]
                cell.titleLabel.text = value
                return cell
            }
            
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = filteredData[indexPath.row]
        delegate?.didSelectedItem(self, item: value, at: indexPath.row, for: searchType)
    }
            
}

extension CustomSearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchBarCancelButtonClicked(searchBar)
            return
        }
        filterRowsForSearchedText(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredData = allData
        tableView.reloadData()
        
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.showsCancelButton = false
    }
}

