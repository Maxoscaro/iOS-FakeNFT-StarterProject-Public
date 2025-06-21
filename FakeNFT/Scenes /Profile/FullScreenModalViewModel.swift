//
//  FullScreenModalViewModel.swift
//  FakeNFT
//
//  Created by Mac on 20.06.2025.
//



import SwiftUI
import PhotosUI

@MainActor

final class FullSrceenModalViewModel: ObservableObject {
    init(model: FullScreenModalModel, selectedItem: PhotosPickerItem? = nil, imageData: Data? = nil) {
        self.model = model
        self.selectedItem = selectedItem
        self.imageData = imageData
        
    }
    
    @Published var model: FullScreenModalModel
    @State var selectedItem: PhotosPickerItem? = nil
    @AppStorage("savedImage") var imageData: Data?
    
}
