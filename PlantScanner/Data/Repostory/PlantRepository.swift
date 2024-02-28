//
//  PlantRepository.swift
//  PlantScanner
//
//  Created by FILALI Salah on 27/02/2024.
//

import Combine
import Foundation

/// Contains the abstraction of methods for performing API

protocol PlantRepository {
    
    /// Send data   to GPT to analyse it
    /// - Returns: AnyPublisher with String value containing GPT response or error
    func sendImageData(_ data: String, apiKey: String) -> AnyPublisher<String, Error>
    
}
