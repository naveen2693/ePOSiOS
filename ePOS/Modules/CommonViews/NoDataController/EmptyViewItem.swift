//
//  EmptyViewItem.swift
//  ePOS
//
//  Created by Matra Sharma on 13/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

enum EmptyItemType: Int {
    case noUser
    case noTransaction
    case noBrand
}

protocol EmptyViewItemProtocol {
    var title: String {get}
    var message: String {get}
    var imageName: String {get}
    var isButtonHidden: Bool {get}
    var buttonTitle: String {get}
    var itemType: EmptyItemType {get}
}

struct NoUserItem: EmptyViewItemProtocol {
    
    var buttonTitle: String {
        return "Add User"
    }
    
    var itemType: EmptyItemType {
        return .noUser
    }
    
    var title: String {
        return "No Users"
    }
    
    var message: String {
        return "Make your workforce mobile! Add user(s), & collect more payments"
    }
    
    var imageName: String {
        return "noUserIcon"
    }
    
    var isButtonHidden: Bool {
        return false
    }
    
}

struct NoTransactionItem: EmptyViewItemProtocol {
    
    var buttonTitle: String {
        return "Make Payments"
    }
    
    var itemType: EmptyItemType {
        return .noTransaction
    }
    
    var title: String {
        return ""
    }
    
    var message: String {
        return ""
    }
    
    var imageName: String {
        return ""
    }
    
    var isButtonHidden: Bool {
        return false
    }
    
}

struct NoBrandItem: EmptyViewItemProtocol {
    
    var buttonTitle: String {
        return "Add Brand"
    }
    
    var itemType: EmptyItemType {
        return .noBrand
    }
    
    var title: String {
        return "No Brand"
    }
    
    var message: String {
        return "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
    }
    
    var imageName: String {
        return ""
    }
    
    var isButtonHidden: Bool {
        return false
    }
    
}
