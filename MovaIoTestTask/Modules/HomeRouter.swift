//
//  HomeRouter.swift
//  MovaIoTestTask
//
//  Created by Serhii Rosovskyi on 13.04.2020.
//  Copyright © 2020 Serhii Rosovskyi. All rights reserved.
//

import UIKit
import SwinjectStoryboard

final class HomeRouter {
    
    weak var viewController: UIViewController?
    
    deinit {
        print("deinit HomeRouter")
    }
}

extension HomeRouter: HomeRouterProtocol {
    
}

