//
//  CryptocurrencyListViewController.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/01.
//

import UIKit
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
            if self?.viewModel.currentTag != 1 {
                self?.tableView.reloadData()
            }
        }
        self.viewModel.tickerBTCList.bind { [weak self] data in
            if self?.viewModel.currentTag == 1 || self?.viewModel.currentTag == 2 {
                self?.tableView.reloadData()
            }
        }
        self.viewModel.currentList.bind { [weak self] currencyNameList in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - func<UI>
    private func configureUI() {
        CrypocurrencyKRWListTableViewCell.register(tableView: tableView)
        CrypocurrencyBTCListTableViewCell.register(tableView: tableView)
        setTabButton()
    }
    
    private func setTabButton() {
        tabButtonList = [krwTabButton, btcTabButton, interestTabButton, popularTabButton]
        tabButtonList[0].isChoice = true
        tabButtonList.forEach { (button: TabButton) in
            button.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func buttonDidTap(_ sender: TabButton) {
        tabButtonList.forEach { button in
            button.isChoice = false
        }
        sender.isChoice = true
        viewModel.currentTag = sender.tag
        if sender.tag == 1, viewModel.tabBTCList.isEmpty {
            viewModel.setBTCInitialData()
        }
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
                                     "symbols": self.viewModel.currentList.value.map { "\($0.0)_\(paymentCurrency.value)" },
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
        return viewModel.currentList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentName = viewModel.currentList.value[indexPath.row].0
        switch viewModel.currentList.value[indexPath.row].1 {
        case .KRW:
            guard let data = viewModel.tickerKRWList.value[currentName] else {
                return UITableViewCell()
            }
//            let currency = "\(data.symbol)_\(data.payment.value)"
            let cell = CrypocurrencyKRWListTableViewCell.dequeueReusableCell(tableView: tableView) as CrypocurrencyKRWListTableViewCell
//            cell.setData(data: data,
//                         isInterest: viewModel.getInterestInfo(currency: currency))
            cell.setData(data: data)
            return cell
        case .BTC:
            guard let btcData = viewModel.tickerBTCList.value[currentName] else {
                return UITableViewCell()
            }
            let krwData: CrypotocurrencyKRWListTableViewEntity = viewModel.tickerKRWList.value[currentName] ?? CrypotocurrencyKRWListTableViewEntity()
            let cell = CrypocurrencyBTCListTableViewCell.dequeueReusableCell(tableView: tableView)
            cell.delegate = self
            cell.setData(krwData: krwData, btcData: btcData)
            return cell
        }
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

// MARK: - Delegate
extension CryptocurrencyListViewController: CrypocurrencyListTableViewCellDelegate {
    func setInterestData(interest: InterestCurrency) {
        viewModel.setInterestData(interest: interest)
    }
}
