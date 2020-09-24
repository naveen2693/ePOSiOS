//
//  EPOSLoader.swift
//  ePOS
//
//  Created by Matra Sharma on 24/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class EPOSLoader: UIView {
    
     var view: UIView!
        
    @IBOutlet weak var imageViewAnimation: UIImageView!
    
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
        imageViewAnimation.loadGif(name: "loadingAnimation")
        addSubview(view)
    }
    
    private func _loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("EPOSLoader xib not found")
        }
        
        return nibView
    }
    
    func showLoading(withCompletion completion: (() -> Swift.Void)? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            UIApplication.shared.keyWindow?.addSubview(self)
        }) { _ in
            completion?()
        }
    }
    
    func hideLoading() {
        UIView.animate(withDuration: 0.5, animations: {
        }) { _ in
            self.removeFromSuperview()
        }
    }
        
}
