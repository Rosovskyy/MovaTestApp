//
//  MovaAPI.swift
//  MovaIoTestTask
//
//  Created by Serhii Rosovskyi on 13.04.2020.
//  Copyright © 2020 Serhii Rosovskyi. All rights reserved.
//

import Foundation

class MovaAPI {
    
    static let shared = MovaAPI()
    
    // MARK: - Properties
    private let session = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    
    fileprivate let baseUrl = "https://api.unsplash.com/search"
    fileprivate let token = "LTr_ByJJkG6YPJyY3u_iOujT3yfMeZoNEvqdSbDch40&query=cat"
    
    func getImageByTag(tag: String, success: @escaping (ImageResponse) -> (), failure: @escaping () -> ()) {
        let path = baseUrl + "/photos?client_id=\(token)&query=\(tag)"
        
        guard let url = URL(string: path) else { return }
        
        dataTask = session.dataTask(with: url) { [weak self] data, response, error in
            defer {
              self?.dataTask = nil
            }
            
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let result = (json["results"] as! [AnyObject]).randomElement() {
                    if let imageResponse = ImageResponse(json: result as! [String : Any], tag: tag) {
                        success(imageResponse)
                    } else {
                        failure()
                    }
                }
            } else {
                failure()
            }
        }
        dataTask?.resume()
    }
}
