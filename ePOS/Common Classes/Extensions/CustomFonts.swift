//
//  CustomFonts.swift
//  ePOS
//
//  Created by Matra Sharma on 03/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

extension UIFont {
    
    @objc class func lightFontWith(size:CGFloat ) -> UIFont{
        var newSize = size
//        if UIDevice.current.screenType == .iPhones_6_6s_7_8{
//            newSize += 1
//        }
//        else
            if UIDevice.current.screenType == .iPhones_X_XS || UIDevice.current.screenType == .iPhone_XR_11 {
            newSize += 1
        } else if UIDevice.current.screenType == .iPhones_6Plus_6sPlus_7Plus_8Plus || UIDevice.current.screenType == .iPhone_XSMax_ProMax {
            newSize += 2
        }
        return  UIFont(name: "Roboto-Light", size: newSize)!
    }
    
    @objc class func regularFontWith(size:CGFloat ) -> UIFont{
        var newSize = size
//        if UIDevice.current.screenType == .iPhones_6_6s_7_8{
//            newSize += 1
//        }
//        else
            if UIDevice.current.screenType == .iPhones_X_XS || UIDevice.current.screenType == .iPhone_XR_11 {
            newSize += 1
        } else if UIDevice.current.screenType == .iPhones_6Plus_6sPlus_7Plus_8Plus || UIDevice.current.screenType == .iPhone_XSMax_ProMax {
            newSize += 2
        }
        return  UIFont(name: "Roboto-Regular", size: newSize)!
    }
    
    @objc class func boldFontWith(size:CGFloat ) -> UIFont{
        var newSize = size
//        if UIDevice.current.screenType == .iPhones_6_6s_7_8{
//            newSize += 1
//        }
//        else
            if UIDevice.current.screenType == .iPhones_X_XS || UIDevice.current.screenType == .iPhone_XR_11 {
            newSize += 1
        } else if UIDevice.current.screenType == .iPhones_6Plus_6sPlus_7Plus_8Plus || UIDevice.current.screenType == .iPhone_XSMax_ProMax {
            newSize += 2
        }
        return  UIFont(name: "Roboto-Bold", size: newSize)!
    }
    
    @objc class func mediumFontWith(size:CGFloat ) -> UIFont{
        var newSize = size
//        if UIDevice.current.screenType == .iPhones_6_6s_7_8{
//            newSize += 1
//        }
//        else
            if UIDevice.current.screenType == .iPhones_X_XS || UIDevice.current.screenType == .iPhone_XR_11 {
            newSize += 1
        } else if UIDevice.current.screenType == .iPhones_6Plus_6sPlus_7Plus_8Plus || UIDevice.current.screenType == .iPhone_XSMax_ProMax {
            newSize += 2
        }
        return  UIFont(name: "Roboto-Medium", size: newSize)!
    }
    
    
}
