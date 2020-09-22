//
//  SelectPackageViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 22/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class SelectPackageViewController: UIViewController {

    @IBOutlet var carousel: iCarousel!
    var packages = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carousel.type = .coverFlow2
        carousel.delegate = self
        carousel.dataSource = self
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SelectPackageViewController: iCarouselDataSource, iCarouselDelegate {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return packages
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let packageView = PackageView.init(frame: CGRect(x: 0, y: 0, width: 240, height: 460))
        packageView.temp.text = "\(index)"
        return packageView
    }
    
    
}
