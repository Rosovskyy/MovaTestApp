//
//  MainContext.swift
//  MovaIoTestTask
//
//  Created by Serhii Rosovskyi on 13.04.2020.
//  Copyright © 2020 Serhii Rosovskyi. All rights reserved.
//

import Swinject
import SwinjectStoryboard

final class MainContext {
    static let shared = MainContext()
    
    private var currentContext = Container()
    
    func createContext() -> Container {
        let context = Container()
        
        //Services
        context.register(MovaAPI.self) {  _ in MovaAPI() }
        
        //Routers
        context.register(HomeRouter.self) { _ in HomeRouter() }
        
        //ViewModels
        context.register(HomeViewModel.self) { r in
            let vm = HomeViewModel(
                api: r.resolve(MovaAPI.self)!
            )
            return vm
            }.inObjectScope(.container)
        
        //Views
        context.storyboardInitCompleted(HomeViewController.self) { r, c in
            let router = r.resolve(HomeRouter.self)
            let vm = r.resolve(HomeViewModel.self)
            router?.viewController = c
            c.viewModel = vm
            c.router = router
        }
        
        self.currentContext = context
        return context
    }
    
    var context: Container {
        get {
            return self.currentContext
        }
    }
}

