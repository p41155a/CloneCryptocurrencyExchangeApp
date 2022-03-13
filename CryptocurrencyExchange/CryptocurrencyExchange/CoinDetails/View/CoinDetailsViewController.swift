//
//  CoinDetailsViewController.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/02.
//

import UIKit
import Starscream

class CoinDetailsViewController: ViewControllerInjectingViewModel<CoinDetailsViewModel> {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var interestButton: StarButton!
    @IBOutlet weak var topTabBarContainer: UIView!
    @IBOutlet weak var topTabBar: UIStackView!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var changeRateLabel: UILabel!
    @IBOutlet weak var changeAmountLabel: UILabel!
    @IBOutlet weak var lineChartView: LineChart!
    
    /// 상단 탭별 연결되는 ViewController를 정의
    var viewControllerByTab: [CoinDetailsTopTabs: UIViewController] = [:]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setChildViewControllers()
        setTopTapBarTabEvent()
        self.bindClosures()
        
        self.bringSubviewToFront(with: CoinDetailsTopTabs(rawValue: 0) ?? .orderbook)
        self.setTabBarButtonUI(selectedButtonTag: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.connectSocket()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.disconnectSocket()
    }
    
    private func configureUI() {
        titleLabel.text = viewModel.dependency.order
        reflectData(by: viewModel.dependency)
        interestButton.isSelected = viewModel.isInterest()
        drawLineChart()
    }
    
    private func bindClosures() {
        // WebSocket Ticker 데이터 반환
        viewModel.tickerData.bind { [weak self] tickerData in
            /// 상단 헤더에서 사용하기 위한 처리
            guard let data = tickerData else { return }
            let entity = CryptocurrencyListTableViewEntity(
                currentPrice: data.closePrice.doubleValue ?? 0,
                changeRate: data.chgRate.doubleValue ?? 0,
                changeAmount: data.chgAmt
            )
            self?.reflectData(by: entity)
            
            /// 호가 창에서 사용하기 위한 데이터
            if let orderBookVC = self?.viewControllerByTab[.orderbook] as? OrderbookViewController {
                let viewModel = orderBookVC.viewModel
                viewModel.closedPrice.value = tickerData?.closePrice ?? ""
                viewModel.fasteningStrengthList.value = tickerData?.volumePower ?? ""
                viewModel.tradeDescriptionList.value.append(data.generate())
            }
        }
        
        // WebSocket Transaction 데이터 반환
        viewModel.transactionData.bind { [weak self] transactionData in
            guard let data = transactionData else { return }
            
            /// 시세창에서 사용
            if let transactionListVC = self?.viewControllerByTab[.transaction] as? TransactionListViewController {
                transactionListVC.transactionDataFromSocket(data)
            }
            
            /// 호가 창에서 사용하기 위한 데이터
            if let orderBookVC = self?.viewControllerByTab[.orderbook] as? OrderbookViewController {
                let viewModel = orderBookVC.viewModel
                let transactionInfo = data.list.map {
                    $0.generate()
                }.reversed()
                
                viewModel.transactionList.value.insert(contentsOf: transactionInfo, at: Int.zero)
            }
        }
        
        viewModel.error.bind { [weak self] error in
            guard let error = error else { return }
            self?.showAlert(title: error) {}
        }
        
    }
    
    // MARK: - func<UI>
    func drawLineChart() {
        viewModel.setInitialDataForChart() { [weak self] data in
            let oneDayToSec: Double = 86400
            let startSec = Date().timeIntervalSince1970 - (oneDayToSec * 30 * 6)
            let openPrice = data.data
                .compactMap { StickInfo(data: $0) }
                .filter { $0.time > startSec * 1000 }
                .map { $0.openPrice }
            
            self?.lineChartView.drawChart(data: openPrice)
        }
    }
    
    func reflectData(by data: CryptocurrencyListTableViewEntity) {
        let currentPrice: String = "\(data.currentPrice)".setNumStringForm(isDecimalType: true)
        let changeRate: String = "\(data.changeRate.displayDecimal(to: 2).setNumStringForm(isMarkPlusMiuns: true))%"
        let changeAmount: String = "\(data.changeAmount)".setNumStringForm(isDecimalType: true, isMarkPlusMiuns: true)
        currentPriceLabel.text = currentPrice
        changeRateLabel.text = changeRate
        changeAmountLabel.text = changeAmount
        setColor(updown: UpDown(rawValue: changeAmount.first ?? "0") ?? .zero)
    }
    
    func setColor(updown: UpDown) {
        currentPriceLabel.textColor = updown.color
        changeRateLabel.textColor = updown.color
        changeAmountLabel.textColor = updown.color
    }

    // MARK: - Private Func
    /// 상단 탭에 연관되는 뷰컨트롤러를 ChildViewController로 설정
    private func setChildViewControllers() {
        let orderCurrency = viewModel.orderCurrency()
        let paymentCurrency = viewModel.paymentCurrency()
        
        let orderbookViewController = OrderbookViewController(
            viewModel: OrderbookViewModel(
                nibName: "OrderbookViewController",
                orderCurrency: .appoint(name: orderCurrency),
                paymentCurrency: PaymentCurrency(rawValue: paymentCurrency) ?? .KRW
            )
        )
        
        let chartViewController = ChartByTimesViewController(
            viewModel: ChartByTimesViewModel(
                nibName: "ChartByTimesViewController",
                repository: ProductionCandleStickRepository(),
                orderCurrency: .appoint(name: orderCurrency),
                paymentCurrency: PaymentCurrency(rawValue: paymentCurrency) ?? .KRW
            )
        )
        
        let transactionListViewController = TransactionListViewController(
            viewModel: TransactionListViewModel(
                nibName: "TransactionListViewController",
                paymentCurrency: paymentCurrency,
                orderCurrency: orderCurrency
            )
        )
        
        viewControllerByTab[.orderbook] = orderbookViewController
        viewControllerByTab[.chart] = chartViewController
        viewControllerByTab[.transaction] = transactionListViewController
        
        viewControllerByTab.values.forEach {
            self.addChildVC($0)
        }
    }
    
    /// 상단 탭을 누름에 따라 touch 이벤트가 동작하도록 설정
    private func setTopTapBarTabEvent() {
        topTabBar.arrangedSubviews.enumerated().forEach { (index, button) in
            guard let button = button as? UIButton else { return }
            button.tag = index
            button.layer.cornerRadius = 8
            button.clipsToBounds = true
            button.layer.borderColor = UIColor.baseColor?.cgColor
            button.layer.borderWidth = 1
            button.titleLabel?.textColor = .titleColor
            button.addTarget(
                self,
                action: #selector(didTapTab(selectedButton:)),
                for: .touchUpInside
            )
        }
    }
    
    /// touch 이벤트가 발생할 때마다 누른 탭에 연관되는 view를 최상단 subView로 가져온다
    @objc func didTapTab(selectedButton: UIButton) {
        guard let tabType = CoinDetailsTopTabs(rawValue: selectedButton.tag) else { return }
        self.bringSubviewToFront(with: tabType)
        self.setTabBarButtonUI(selectedButtonTag: selectedButton.tag)
    }
    
    private func setTabBarButtonUI(selectedButtonTag: Int) {
        topTabBar.arrangedSubviews.enumerated().forEach { (index, button) in
            guard let button = button as? UIButton else { return }
            let isSelectedButton = selectedButtonTag == index
            button.backgroundColor = isSelectedButton ? .baseColor : .clear
        }
    }
    
    private func bringSubviewToFront(with type: CoinDetailsTopTabs) {
        guard let tappedView = viewControllerByTab[type]?.view else { return }
        self.view.bringSubviewToFront(tappedView)
    }
    
    private func addChildVC(_ viewController: UIViewController) {
        self.addChild(viewController)
        self.view.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: self.topTabBarContainer.bottomAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        viewController.didMove(toParent: self)
    }
    
    private func removeChildVC(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        viewController.view.removeFromSuperview()
    }
    @IBAction func clickBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func interestButtonTap(_ sender: StarButton) {
        sender.isSelected.toggle()
        viewModel.setInterest(for: sender.isSelected)
    }
}
