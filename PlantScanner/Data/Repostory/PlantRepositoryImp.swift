//
//  PlantRepositoryImp.swift
//  PlantScanner
//
//  Created by FILALI Salah on 27/02/2024.
//

import Combine
import Foundation

/// PokemonRepositoryImp contains the implementaion of PokemonRepository methods
class PlantRepositoryImp: PlantRepository {
    
    // MARK: - Properties
    
    /// remoteAPI is the Provider for API methods
    private let remoteAPI: RemoteAPI
    
    // MARK: - Methods
    init(
        remoteAPI: RemoteAPI
    ) {
        self.remoteAPI = remoteAPI
    }
    
    func sendImageData(_ data: String, apiKey: String) -> AnyPublisher<String, Error> {
        self.remoteAPI.sendImageData(data, apiKey: apiKey).flatMap{ response -> AnyPublisher<String, Error> in
            Future<String, Error>.init { promise in
                promise(.success("success"))
            }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
}
