//
//  IFSCCodeDetailViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 20/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class IFSCCodeDetailViewController: UIViewController {
    @IBOutlet weak var nextButton: EPOSRoundButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        // Do any additional setup after loading the view.
    }

    private func registerCell() {
        tableView.register(UINib(nibName: IFSCDetailTableViewCell.className, bundle: nil), forCellReuseIdentifier: IFSCDetailTableViewCell.className)
    }

    @IBAction func nextButtonClicked(_ sender: Any) {
    }
    
    @IBAction func moreIFSCClicked(_ sender: Any) {
    }
}

extension IFSCCodeDetailViewController: UITableViewDelegate {
    
}

extension IFSCCodeDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IFSCDetailTableViewCell.className, for: indexPath) as? IFSCDetailTableViewCell else {
            fatalError("IFSCDetailTableViewCell not found for identifier IFSCDetailTableViewCell")
        }
        
        return cell
    }
    
    
}
