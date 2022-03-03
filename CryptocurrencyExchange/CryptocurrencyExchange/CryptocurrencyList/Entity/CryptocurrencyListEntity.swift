//
//  CryptocurrencyListModel.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/02.
//

import Foundation

/// AssetsStatus
struct TickerEntity: Codable {
    let status: String
    let currentInfo: CurrentInfo
}

extension TickerEntity {
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case currentInfo = "data"
    }
}

struct CurrentInfo: Codable {
    var current: [String: TickerInfo]
    
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        var tempDic = [String: TickerInfo]()

        for key in container.allKeys {
            do {
                let decodedObject = try container.decode(TickerInfo.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
                tempDic[key.stringValue] = decodedObject
            } catch {
                
            }
        }
        current = tempDic
    }
}

/// EachAccountStatus
struct TickerInfo: Codable {
    let openingPrice: String?
    let closingPrice: String?
    let minPrice: String?
    let maxPrice: String?
    let unitsTraded: String?
    let accTradeValue: String?
    let prevClosingPrice: String?
    let unitsTraded24H: String?
    let accTradeValue24H: String?
    let fluctate24H: String?
    let fluctateRate24H: String?
    let date: String?
}

extension TickerInfo {
    enum CodingKeys: String, CodingKey {
        case openingPrice = "opening_price"
        case closingPrice = "closing_price"
        case minPrice = "min_price"
        case maxPrice = "max_price"
        case unitsTraded = "units_traded"
        case accTradeValue = "acc_trade_value"
        case prevClosingPrice = "prev_closing_price"
        case unitsTraded24H = "units_traded_24H"
        case accTradeValue24H = "acc_trade_value_24H"
        case fluctate24H = "fluctate_24H"
        case fluctateRate24H = "fluctate_rate_24H"
        case date = "date"
    }
    
    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        openingPrice = try? container.decode(String.self, forKey: CodingKeys.openingPrice)
        closingPrice = try? container.decode(String.self, forKey: CodingKeys.closingPrice)
        minPrice = try? container.decode(String.self, forKey: CodingKeys.minPrice)
        maxPrice = try? container.decode(String.self, forKey: CodingKeys.maxPrice)
        unitsTraded = try? container.decode(String.self, forKey: CodingKeys.unitsTraded)
        accTradeValue = try? container.decode(String.self, forKey: CodingKeys.accTradeValue)
        prevClosingPrice = try? container.decode(String.self, forKey: CodingKeys.prevClosingPrice)
        unitsTraded24H = try? container.decode(String.self, forKey: CodingKeys.unitsTraded24H)
        accTradeValue24H = try? container.decode(String.self, forKey: CodingKeys.accTradeValue24H)
        fluctate24H = try? container.decode(String.self, forKey: CodingKeys.fluctate24H)
        fluctateRate24H = try? container.decode(String.self, forKey: CodingKeys.fluctateRate24H)
        date = try? container.decode(String.self, forKey: CodingKeys.date)
    }
}
