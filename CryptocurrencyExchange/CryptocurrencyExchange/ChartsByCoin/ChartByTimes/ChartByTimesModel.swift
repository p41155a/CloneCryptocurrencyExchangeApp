//
//  ChartByTimesModel.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/3/22.
//

import Foundation

enum TimeIntervalInChart: Int {
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
}

