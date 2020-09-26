//
//  EPOSBaseView.swift
//  ePOS
//
//  Created by Matra Sharma on 25/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class EPOSBaseView: UIView {

    var view: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(view, at: 0)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: EPOSBaseView.className, bundle: bundle)
        guard let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("EPOSBaseView xib not found")
        }
        return nibView
    }
}
