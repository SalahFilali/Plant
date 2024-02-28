//
//  RemoteApiImp.swift
//  PlantScanner
//
//  Created by FILALI Salah on 27/02/2024.
//

import Foundation
import Combine

/// Contains the implementation of methods for performing API  calls.
class RemoteAPIImp: RemoteAPI {
    
    // MARK: - Properties
    private let urlSessionManager: URLSessionManager
    
    // MARK: - Methods
    init(urlSessionManager: URLSessionManager) {
        self.urlSessionManager = urlSessionManager
    }
    
    func sendImageData(_ data: String, apiKey: String) -> AnyPublisher<String, Error>{
        return self.urlSessionManager.defaultDataTask(withRouter: RouterImp.sendImageData(data, apiKey: apiKey), forType: String.self)
    }
    
}
