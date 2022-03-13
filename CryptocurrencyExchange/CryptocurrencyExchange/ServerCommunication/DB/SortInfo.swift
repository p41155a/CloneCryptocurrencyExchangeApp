//
//  SortInfo.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/13.
//

import Foundation
import RealmSwift

class SortInfo: Object {
    @Persisted var primaryKey: String
    @Persisted var standard: MainListSortStandard
    @Persisted var orderby: OrderBy
    
    convenience init(
        standard: MainListSortStandard,
        orderby: OrderBy
    ) {
        self.init()
        self.primaryKey = "sortInfo"
        self.standard = standard
        self.orderby = orderby
    }
    
    override static func primaryKey() -> String {
      return "primaryKey"
    }
}
