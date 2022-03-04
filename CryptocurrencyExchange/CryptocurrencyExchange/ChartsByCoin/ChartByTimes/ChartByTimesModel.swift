//
//  ChartByTimesModel.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/3/22.
//

import Foundation
import RealmSwift

enum TimeIntervalInChart: Int, PersistableEnum {
    case oneMinute = 0
    case tenMinutes = 1
    case thirtyMinutes = 2
    case anHour = 3
    case OneDay = 4
    
    var title: String {
        switch self {
        case .oneMinute: return "1분"
        case .tenMinutes: return "10분"
        case .thirtyMinutes: return "30분"
        case .anHour: return "1시간"
        case .OneDay: return "일"
        }
    }
    
    var urlParameter: String {
        switch self {
        case .oneMinute: return "1m"
        case .tenMinutes: return "10m"
        case .thirtyMinutes: return "30m"
        case .anHour: return "1h"
        case .OneDay: return "24h"
        }
    }
}

