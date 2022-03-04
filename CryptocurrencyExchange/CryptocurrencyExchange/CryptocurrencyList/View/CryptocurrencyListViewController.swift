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
            self?.tableView.reloadData()
        }
        self.viewModel.currencyNameList.bind { [weak self] currencyNameList in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - func<UI>
    private func configureUI() {
        CrypocurrencyListTableViewCell.register(tableView: tableView)
        setTabButton()
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
    
    private func writeToSocket(paymentCurrency: PaymentCurrency, tickTypes: [WebSocketTickType]) {
        let params: [String: Any] = ["type": WebSocketType.ticker.rawValue,
                                     "symbols": self.viewModel.currencyNameList.value.map { "\($0)_\(paymentCurrency.value)" },
                                     "tickTypes": tickTypes.map { $0.rawValue } ]
        
        let json = try! JSONSerialization.data(withJSONObject: params, options: [])
        socket?.write(string: String(data:json, encoding: .utf8)!, completion: nil)
    }
    
    // MARK: - Property
    private var socket: WebSocket?
    private var tabButtonList: [TabButton] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var krwTabButton: TabButton!
    @IBOutlet weak var btcTabButton: TabButton!
    @IBOutlet weak var interestTabButton: TabButton!
    @IBOutlet weak var popularTabButton: TabButton!
}
// MARK: - TableView
extension CryptocurrencyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currencyNameList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentName = viewModel.currencyNameList.value[indexPath.row]
        guard let data = viewModel.tickerKRWList.value[currentName] else {
            return UITableViewCell()
        }
        let cell = CrypocurrencyListTableViewCell.dequeueReusableCell(tableView: tableView)
        cell.setData(data: data)
        return cell
    }
}
// MARK: - TableView
extension CryptocurrencyListViewController: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(_):
            writeToSocket(paymentCurrency: .KRW, tickTypes: [.tickMID])
        case .text(let string):
            do {
                let data = string.data(using: .utf8)!
                let json = try JSONDecoder().decode(WebSocketTickerEntity.self, from: data)
                viewModel.setWebSocketData(with: json)
            } catch  {
                print("Received text: \(string)")
            }
        default:
            break
        }
    }
}
