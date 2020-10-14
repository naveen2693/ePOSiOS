//
//  PackageDetailViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 22/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class PackageDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        // Do any additional setup after loading the view.
    }

    class func viewController() -> PackageDetailViewController {
        let controller = PackageDetailViewController.init(nibName: PackageDetailViewController.className, bundle: nil)
        return controller
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: PackageDetailTableViewCell.className, bundle: nil), forCellReuseIdentifier: PackageDetailTableViewCell.className)
    }
    
    @IBAction func selectPackageClicked(_ sender: Any) {
    }
    
}

//MARK: TableViewDelegate DataSource
extension PackageDetailViewController: UITableViewDelegate {
    
}

extension PackageDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PackageDetailTableViewCell.className, for: indexPath) as? PackageDetailTableViewCell else {
            fatalError("IFSCDetailTableViewCell not found for identifier IFSCDetailTableViewCell")
        }
        
        return cell
    }
    
    
}
