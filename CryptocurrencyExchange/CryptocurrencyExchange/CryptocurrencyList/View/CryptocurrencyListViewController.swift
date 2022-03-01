//
//  CryptocurrencyListViewController.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/01.
//

import UIKit
import SnapKit
import Starscream

final class CryptocurrencyListViewController: ViewControllerInjectingViewModel<CryptocurrencyListViewModel> {
    private var socket: WebSocket?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        apiManager.fetchTickerStatus(cryptocurrencyName: "BTC", paymentCurrency: .KRW) { data in
            print(data)
        }
        apiManager.fetchTickerStatus(paymentCurrency: .KRW) { data in
            print(data)
        }
//        connect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    deinit {
//        disconnect()
    }
    
    // MARK: - func<UI>
    private func configureUI() {
        setContentView()
        setTabButton()
    }
    
    private func setContentView() {
        guard let cryptocurrencyListView = CryptocurrencyListView.loadFromNib() else {
            return
        }
        contentView.addSubview(cryptocurrencyListView)
        
        cryptocurrencyListView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setTabButton() {
        tabButtonList = [krwTabButton, btcTabButton, interestTabButton, popularTabButton]
        tabButtonList.first?.isChoice = true
        tabButtonList.forEach { button in
            button.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func buttonDidTap(_ sender: TabButton) {
        tabButtonList.forEach { button in
            button.isChoice = false
        }
        sender.isChoice = true
    }
    
    // MARK: - func<websocket>
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
        socket?.delegate = nil
    }
    
    // MARK: - Property
    private var tabButtonList: [TabButton] = []
    private var apiManager = TickerAPIManager()
    @IBOutlet weak var krwTabButton: TabButton!
    @IBOutlet weak var btcTabButton: TabButton!
    @IBOutlet weak var interestTabButton: TabButton!
    @IBOutlet weak var popularTabButton: TabButton!
    @IBOutlet weak var contentView: UIView!
}
extension CryptocurrencyListViewController: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            let params: [String: Any] = ["type": WebSocketType.ticker.rawValue,
                                         "symbols":["BTC_\(PaymentCurrency.KRW.rawValue)"],
                                         "tickTypes": [WebSocketTickType.tickMID.rawValue]]
            
            let jParams = try! JSONSerialization.data(withJSONObject: params, options: [])
            client.write(string: String(data:jParams, encoding: .utf8)!, completion: nil)
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            do {
                let data = string.data(using: .utf8)!
                let json = try JSONDecoder().decode(WebSocketTickerEntity.self, from: data)
                print("파싱완료한 데이터: \(json)")
            } catch  {
                print("Received text: \(string)")
            }
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

