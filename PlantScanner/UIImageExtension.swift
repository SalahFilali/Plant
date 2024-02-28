//
//  UIImageExtension.swift
//  PlantScanner
//
//  Created by FILALI Salah on 28/02/2024.
//

import UIKit

extension UIImage {
    var base64: String? {
        self.jpegData(compressionQuality: 0.0)?.base64EncodedString()
    }
}
