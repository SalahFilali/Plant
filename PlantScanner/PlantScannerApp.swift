//
//  PlantScannerApp.swift
//  PlantScanner
//
//  Created by FILALI Salah on 27/02/2024.
//

import SwiftUI

@main
struct PlantScannerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            CameraView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
