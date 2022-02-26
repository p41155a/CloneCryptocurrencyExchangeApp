//
//  ViewControllerInjectingViewModel.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/02/25.
//

import UIKit

/// XiB로 만든 ViewController를 생성할 때 제공해야 하는 프로토콜
protocol ViewControllerFromNib {
    var nibName: String? { get }
}

/// ViewControllerFromNib을 채택하는 뷰모델로 초기화하는 이니셜라이저를 제공하는 프로토콜
protocol ViewControllerForMVVM: AnyObject {
    associatedtype T: ViewControllerFromNib
    init(viewModel: T)
}

/// 뷰모델을 주입하여 XIB로부터 생성되는 뷰컨트롤러
class ViewControllerInjectingViewModel<U: ViewControllerFromNib>: UIViewController, ViewControllerForMVVM {
    typealias T = U
    let viewModel: T
    
    required init?(coder: NSCoder) {
        fatalError("viewModel이 없는 뷰컨트롤러는 생성할 수 없습니다")
    }
    
    required init(viewModel: T) {
        self.viewModel = viewModel
        super.init(
            nibName: viewModel.nibName,
            bundle: nil
        )
    }
}
