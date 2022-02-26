//
//  DemoNetworkViewController.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/26.
//

import UIKit
import Starscream

final class DemoNetworkViewController: UIViewController {
    // MARK: - Property
    private var socket: WebSocket?
    var apiManager = AssetsAPIManager()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        apiManager.assetsStatus { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print("error: \(error)")
            }
        }
        
        connect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disconnect()
    }
    
    // MARK: - func
    private func connect() {
        let url = "wss://pubwss.bithumb.com/pub/ws"
        
        var request = URLRequest(url: URL(string: url)!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
    
    private func disconnect() {
        socket?.disconnect()
    }
}

extension DemoNetworkViewController: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            let params: [String: Any] = ["type":"ticker",
                                         "symbols":["BTC_KRW"],
                                         "tickTypes": ["24H"]]
            
            let jParams = try! JSONSerialization.data(withJSONObject: params, options: [])
            client.write(string: String(data:jParams, encoding: .utf8)!, completion: nil)
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
        case .error(let error):
            print(error?.localizedDescription ?? "")
            break
        default:
            break
        }
    }
}
