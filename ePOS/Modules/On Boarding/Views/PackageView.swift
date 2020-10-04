//
//  PackageView.swift
//  ePOS
//
//  Created by Matra Sharma on 22/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class PackageView: UIView {
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var view: UIView!
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            _setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self._setup()
        }
        
        private func _setup() {
            view = _loadViewFromNib()
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.translatesAutoresizingMaskIntoConstraints = true
            addSubview(view)
        }
        
        private func _loadViewFromNib() -> UIView {
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
            guard let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
                fatalError("packageview xib not found")
            }
            return nibView
        }
    
    
    
    @IBAction func viewRatesClicked(_ sender: Any) {
    }
    
}


//extension PackageView: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//
//}
