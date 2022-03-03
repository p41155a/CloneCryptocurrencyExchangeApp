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
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.setKRWInitialData()
        bind()
        connect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    deinit {
        disconnect()
    }
    
    func bind() {
        self.viewModel.tickerKRWList.bind { [weak self] data in
            self?.cryptocurrencyListView?.dataForTableView.value = data
        }
        self.viewModel.currencyNameList.bind { [weak self] currencyNameList in
            self?.cryptocurrencyListView?.currencyNameList = currencyNameList
        }
    }
    
    // MARK: - func<UI>
    private func configureUI() {
        setContentView()
        setTabButton()
    }
    
    private func setContentView() {
        guard let cryptocurrencyListView = cryptocurrencyListView else { return }
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
    let cryptocurrencyListView = CryptocurrencyListView.loadFromNib()
    private var socket: WebSocket?
    private var tabButtonList: [TabButton] = []
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
                                         "symbols": self.viewModel.currencyNameList.value.map { "\($0)_\(PaymentCurrency.KRW.value)" },
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
                viewModel.setWebSocketData(with: json)
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
