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
}
