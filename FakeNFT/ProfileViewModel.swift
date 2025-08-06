//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by Mac on 12.06.2025.
//

import Foundation
import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @AppStorage("userData") private var storedData: Data = Data()
    
    @Published var name: String = ""
    @Published var avatar: String = ""
    @Published var description: String = ""
    @Published var link: String = ""
    @Published var nfts: [Nft] = []
    @Published var favoritesNfts: [Nft] = []
    @Published var imageData: Data?
    @Published var isLoading: Bool = false

    
    enum SortOption: String, CaseIterable, Identifiable {
        case name = "По названию"
        case price = "По цене"
        case rating = "По рейтингу"
        
        var id: String { rawValue }
    }
    @AppStorage("selectedSortOption") private var storedSortOption: String = SortOption.name.rawValue

    private var userLikes = UserLikes(likes: [])
    private var didLoadNFTs = false
    
    private let profileService: ProfileService
    private let nftsService: NftService
    private let likesService: LikesService
    
    var selectedSortOption: SortOption {
        get{ SortOption(rawValue: storedSortOption) ?? .name}
        set { storedSortOption = newValue.rawValue }
    }
    
    var sortedNFTs: [Nft] {
        switch selectedSortOption {
        case .name:
            return nfts.sorted { $0.name < $1.name }
        case .price:
            return nfts.sorted { $0.price < $1.price }
        case .rating:
            return nfts.sorted { $0.rating > $1.rating }
        }
    }
    init(profileService: ProfileService, nftsService: NftService, likesService: LikesService) {
        self.profileService = profileService
        self.nftsService = nftsService
        self.likesService = likesService
    }
    
    func save(name: String, description: String, link: String, imageData: Data?) {
        let newData = UserData(name: name, description: description, link: link, imageData: imageData)
            if let encoded = try? JSONEncoder().encode(newData) {
                storedData = encoded
                self.name = name
                self.description = description
                self.link = link
                self.imageData = imageData
            }
        }
    
    func fetchProfile() async  {
        isLoading = true
        
        await profileService.fetchProfile { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let fetchedProfile):
                self.name = fetchedProfile.name
                self.avatar = fetchedProfile.avatar
                self.description = fetchedProfile.description ?? ""
                self.link = fetchedProfile.website
                
                // Основные NFT загружаем только один раз
                if !didLoadNFTs {
                    fetchOwnNfts(fetchedProfile.nfts)
                    didLoadNFTs = true
                }
                
                // Избранные NFT всегда обновляем с сервера
                self.favoritesNfts.removeAll()
                fetchFavoritesNfts(fetchedProfile.likes)
                
            case .failure(let error):
                print("Ошибка загрузки профиля: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
    }
    
    func isLiked(_ nft: Nft) -> Bool{
        favoritesNfts.contains(where: { $0.id == nft.id})
    }
    
    func toggleLike(for nft: Nft) {
        // Сначала обновляем локальный массив
        if let index = self.favoritesNfts.firstIndex(of: nft) {
            self.favoritesNfts.remove(at: index)
        } else {
            self.favoritesNfts.append(nft)
        }
        
        // Затем синхронизируем с сервером
        userLikes = UserLikes(likes: favoritesNfts.map { $0.id })
        print("Отправляем на сервер: \(userLikes.likes.count) лайков")
        
        likesService.updateLikes(likes: userLikes) {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                print("SUCCESS: лайки обновлены на сервере")
            case .failure(let error):
                print("Ошибка при обновлении лайков: \(error.localizedDescription)")
                // В случае ошибки можно откатить изменения
                // или показать пользователю сообщение об ошибке
            }
        }
    }
    
    private func fetchOwnNfts(_ nftIds: [String]) {
        if nftIds.isEmpty {
            isLoading = false
            return
        }
        
        var loadedCount = 0
        let totalCount = nftIds.count
        
        nftIds.forEach { id in
            nftsService.loadNft(id: id) {
                switch $0 {
                case .success(let nft):
                    self.nfts.append(nft)
                    
                case .failure(let error):
                    print("Ошибка загрузки NFT: \(error.localizedDescription)")
                }
                
                loadedCount += 1
                if loadedCount == totalCount {
                    self.isLoading = false
                }
            }
        }
    }
    
    private func fetchFavoritesNfts(_ nftIds: [String]) {
        if nftIds.isEmpty {
            return
        }
        
        var loadedCount = 0
        let totalCount = nftIds.count
        
        nftIds.forEach { id in
            nftsService.loadNft(id: id) {
                switch $0 {
                case .success(let nft):
                    self.favoritesNfts.append(nft)
                    
                case .failure(let error):
                    print("Ошибка загрузки NFT: \(error.localizedDescription)")
                }
                
                loadedCount += 1
                if loadedCount == totalCount {
                    self.isLoading = false
                }
            }
        }
    }
    
    private func fetchLikedNfts(_ nftIds: [String]) {
        
    }
    
}


