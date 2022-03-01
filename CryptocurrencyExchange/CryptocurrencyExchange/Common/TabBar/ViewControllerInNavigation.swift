//
//  ViewControllerInNavigation.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/02/27.
//

import UIKit

// 탭바 컨트롤러를 구성할 뷰컨트롤러 생성을 위한 정보
struct TabInformation {
    let viewController: UIViewController
    let tabTitle: String
    let image: UIImage
}

// 주입한 뷰컨트롤러가 rootViewController인 네비게이션컨트롤러 생성
struct ViewControllerInNavigation {
    let info: TabInformation
    
    init(with info: TabInformation) {
        self.info = info
    }
    
    func navigationControllerIncludingViewController() -> UINavigationController {
        let navigation = UINavigationController(rootViewController: info.viewController)
        navigation.tabBarItem = UITabBarItem(
            title: info.tabTitle,
            image: info.image,
            tag: 0
        )
        return navigation
    }
}

