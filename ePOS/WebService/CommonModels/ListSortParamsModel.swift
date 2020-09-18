//
//  ListSortParams.swift
//  ePOS
//
//  Created by Abhishek on 17/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public class ListSortParamsModel{
private var direction:String?;
private var page:Int?
private var size:Int?;
private var sort:String?

public func getDirection() -> String {
    if let unwrappedDirection = direction {
        return unwrappedDirection;
    } else {
        fatalError("Error: UserRegistrationDataModel:getReferralCode  failed.")
    }
}

public func setDirection(direction:String) -> ListSortParamsModel {
    self.direction = direction;
    return self
}

public func getPage() -> Int{
    if let unwrappedPage = page {
        return unwrappedPage;
    } else {
        fatalError("Error: UserRegistrationDataModel:getContactName  failed.")
    }
}

public func setPage(page:Int) -> ListSortParamsModel{
    self.page = page;
    return self
}

public func getSize() -> Int {
    if let unwrappedSize = size {
        return unwrappedSize;
    } else {
        fatalError("Error: UserRegistrationDataModel:getReferralCode  failed.")
    }
}

public func setSize(size:Int) -> ListSortParamsModel {
    self.size = size;
    return self
}

public func getSort() -> String{
    if let unwrappedSort = sort {
        return unwrappedSort;
    } else {
        fatalError("Error: UserRegistrationDataModel:getContactName  failed.")
    }
}

public func setSort(sort:String) -> ListSortParamsModel{
    self.sort = sort;
    return self
}



}
