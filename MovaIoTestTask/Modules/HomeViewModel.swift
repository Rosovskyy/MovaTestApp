//
//  HomeViewModel.swift
//  MovaIoTestTask
//
//  Created by Serhii Rosovskyi on 13.04.2020.
//  Copyright © 2020 Serhii Rosovskyi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: HomeVMProtocol {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    var api: MovaAPI
    
    let imagesList = BehaviorRelay<[ImageResponse]>(value: [])
    let requestFailure = PublishRelay<Void>()
    
    // MARK: - Initialization
    init(api: MovaAPI) {
        self.api = api
    }
}

extension HomeViewModel {
    func getImageByTag(tag: String) {
        api.getImageByTag(tag: tag, success: { (resp) in
            var images = self.imagesList.value
            images.insert(resp, at: 0)
            self.imagesList.accept(images)
        }) {
            self.requestFailure.accept(())
        }
    }
}
