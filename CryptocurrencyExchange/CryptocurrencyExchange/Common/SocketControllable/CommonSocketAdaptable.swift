//
//  CommonSocketAdaptable.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/12.
//

import Foundation
import Starscream

protocol CommonSocketAdaptable: WebSocketDelegate {
    var socket: WebSocket? { get }
    func connect()
    func disconnect()
}
