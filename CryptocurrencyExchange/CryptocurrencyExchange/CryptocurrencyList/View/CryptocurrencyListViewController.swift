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
        viewModel.setInitialData()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    // MARK: - Bind viewModel
    func bind() {
        self.viewModel.currentList.bind { [weak self] currencyNameList in
            self?.tableView.reloadData()
        }
        
        self.viewModel.changeIndex.bind { [weak self] index in
            self?.tableView.beginUpdates()
            let index = IndexPath(item: index, section: 0)
            self?.tableView.reloadRows(at: [index], with: .fade)
            self?.tableView.endUpdates()
            
            if let cell = self?.tableView.cellForRow(at: index) as? CrypocurrencyKRWListTableViewCell {
                cell.animateBackGroundColor()
            } else if let cell = self?.tableView.cellForRow(at: index) as? CrypocurrencyBTCListTableViewCell {
                cell.animateBackGroundColor()
            }
        }
        
        self.viewModel.error.bind { [weak self] title in
            guard let title = title else { return }
            self?.showAlert(title: title, completion: nil)
        }
    }
    
    // MARK: - func<UI>
    private func configureUI() {
        CrypocurrencyKRWListTableViewCell.register(tableView: tableView)
        CrypocurrencyBTCListTableViewCell.register(tableView: tableView)
        setTabButton()
        setSortButton()
        setEventButton()
        setSearchTextField()
    }
    
    private func setTabButton() {
        tabButtonList = [krwTabButton, btcTabButton, interestTabButton, popularTabButton]
        tabButtonList[0].isChoice = true
        tabButtonList.forEach { (button: TabButton) in
            button.addTarget(self, action: #selector(tabButtonDidTap(_:)), for: .touchUpInside)
        }
    }
    
    private func setEventButton() {
        eventButton.addTarget(self, action: #selector(eventButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private func setSearchTextField() {
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setSortButton() {
        sortButtonList = [
            sortCurrencyNameButton,
            sortCurrentPriceButton,
            sortChangeRateButton,
            sortTransactionButton
        ]
        let sortInfo = viewModel.getSortInfo()
        switch sortInfo.standard {
        case .currencyName:
            sortCurrencyNameButton.orderBy = sortInfo.orderby
        case .currentPrice:
            sortCurrentPriceButton.orderBy = sortInfo.orderby
        case .changeRate:
            sortChangeRateButton.orderBy = sortInfo.orderby
        case .transaction:
            sortTransactionButton.orderBy = sortInfo.orderby
        }
        sortButtonList.forEach { (button: SortListButton) in
            button.addTarget(self, action: #selector(sortButtonViewDidTap(_:)), for: .touchUpInside)
        }
    }
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let word = textField.text else { return }
        viewModel.searchCurrency(for: word)
    }
    
    @objc private func eventButtonDidTap(_ sender: UIButton) {
        if let url = URL(string: "https://cafe.bithumb.com/view/board-contents/1642708") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @objc private func tabButtonDidTap(_ sender: TabButton) {
        setChoiceOnlyCurrentTap(sender)
        viewModel.chageCurrentTab(sender.tag)
    }
    
    @objc private func sortButtonViewDidTap(_ sender: SortListButton) {
        setChoiceOnlyCurrentSortButtonView(sender)
        switch sender.tag {
        case 0:
            viewModel.sortCurrentTabList(orderBy: sender.orderBy ?? .desc, standard: .currencyName)
        case 1:
            viewModel.sortCurrentTabList(orderBy: sender.orderBy ?? .desc, standard: .currentPrice)
        case 2:
            viewModel.sortCurrentTabList(orderBy: sender.orderBy ?? .desc, standard: .changeRate)
        default:
            viewModel.sortCurrentTabList(orderBy: sender.orderBy ?? .desc, standard: .transaction)
        }
    }
    
    private func setChoiceOnlyCurrentTap(_ sender: TabButton) {
        tabButtonList.forEach { button in
            button.isChoice = false
        }
        sender.isChoice = true
        sortStackView.isHidden = sender.tag == 3 // 인기일때만 숨김
        explainPopolurRuleLabel.isHidden = !(sender.tag == 3)
    }
    
    private func setChoiceOnlyCurrentSortButtonView(_ sender: SortListButton) {
        sortButtonList.filter {
            $0 != sender
        }.forEach { button in
            button.orderBy = nil
        }
        sender.isClicked()
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
    private var sortButtonList: [SortListButton] = []
    @IBOutlet weak var explainPopolurRuleLabel: UILabel!
    @IBOutlet weak var sortStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var krwTabButton: TabButton!
    @IBOutlet weak var btcTabButton: TabButton!
    @IBOutlet weak var interestTabButton: TabButton!
    @IBOutlet weak var popularTabButton: TabButton!
    @IBOutlet weak var sortCurrencyNameButton: SortListButton!
    @IBOutlet weak var sortCurrentPriceButton: SortListButton!
    @IBOutlet weak var sortChangeRateButton: SortListButton!
    @IBOutlet weak var sortTransactionButton: SortListButton!
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
}
// MARK: - TableView
extension CryptocurrencyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentName = viewModel.currentList.value[indexPath.row].0
        let paymentCurrency = viewModel.currentList.value[indexPath.row].1
        switch paymentCurrency {
        case .KRW:
            guard let data = viewModel.tickerKRWList[currentName] else {
                return UITableViewCell()
            }
            let currency = "\(data.symbol)_KRW"
            let cell = CrypocurrencyKRWListTableViewCell.dequeueReusableCell(tableView: tableView)
            cell.delegate = self
            cell.setData(data: data,
                         isInterest: viewModel.isInterest(interestKey: currency))
            return cell
        case .BTC:
            guard let btcData = viewModel.tickerBTCList[currentName] else {
                return UITableViewCell()
            }
            let currency = "\(btcData.symbol)_BTC"
            let krwData = viewModel.tickerKRWList[currentName] ?? CryptocurrencyListTableViewEntity()
            let cell = CrypocurrencyBTCListTableViewCell.dequeueReusableCell(tableView: tableView)
            cell.delegate = self
            cell.setData(krwData: krwData, btcData: btcData,
                         isInterest: viewModel.isInterest(interestKey: currency))
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

// MARK: - TextField
extension CryptocurrencyListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.searchCurrency(for: "")
        return true
    }
}
