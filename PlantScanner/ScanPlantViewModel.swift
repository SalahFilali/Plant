//
//  ScanPlantViewModel.swift
//  PlantScanner
//
//  Created by FILALI Salah on 27/02/2024.
//

import Foundation
import Combine
import UIKit

class ScanPlantViewModel:ObservableObject {
    
    // MARK: - Properties
    let plantRepository: PlantRepository
    var imageData: Data?
    let apiKey = "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"
    
    var cancellable: AnyCancellable?
    
    // MARK: - Methods
    init(plantRepository: PlantRepository) {
        self.plantRepository = plantRepository
    }
    
    func sendImageData(_ image: UIImage?) {
        guard let image = image else { return }
        let base64 = image.base64
        cancellable = self.plantRepository.sendImageData(base64!, apiKey: apiKey)
            .receive(on: DispatchQueue.main)
            .sink { response in
                switch response {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("Error: \(error)")
                }
            } receiveValue: { response in
                print("Resonse success: \(response)")
            }
    }

}
