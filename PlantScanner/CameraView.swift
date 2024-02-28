//
//  CameraView.swift
//  PlantScanner
//
//  Created by FILALI Salah on 27/02/2024.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    
    @State private var showCamera = false
    @State private var image: UIImage?
    
    var body: some View {
        Button(action: {
            self.showCamera.toggle()
        }) {
            Text("Take Photo")
        }
        .sheet(isPresented: $showCamera) {
            CameraCaptureView(image: self.$image)
        }
    }
}

struct CameraCaptureView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraCaptureView
        @ObservedObject var viewModel = ScanPlantViewModel(
            plantRepository: PlantRepositoryImp(
                remoteAPI: RemoteAPIImp(
                    urlSessionManager: URLSessionManager()
                )
            )
        )
        
        init(parent: CameraCaptureView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
                self.viewModel.sendImageData(image)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
