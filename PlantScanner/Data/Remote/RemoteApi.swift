//
//  RemoteApi.swift
//  PlantScanner
//
//  Created by FILALI Salah on 27/02/2024.
//

import Combine
import Foundation


/// Contains the abstraction of methods for performing API  calls.
protocol RemoteAPI {
    
    func sendImageData(_ data: String, apiKey: String) -> AnyPublisher<String, Error>
    
}
