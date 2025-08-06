//
//  Favourites.swift
//  FakeNFT
//
//  Created by Mac on 17.06.2025.
//

import SwiftUI

struct FavouritesView: View {
    @EnvironmentObject var viewModel: ProfileViewModel


    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        NavigationView {
            VStack{
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .tint(.gray)
                }
                else if viewModel.favoritesNfts.isEmpty {
                    Text("Нет избранных NFT")
                        .font(.custom("SFProText-Bold", size: 17))
                        .padding()
                    
                } else {
                    ScrollView{
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(viewModel.favoritesNfts) { nft in
                                FavouriteNft(nft: nft)
                            }
                        }
                        .padding()
                    }
                }
            }
                .modifier(NavigationBarStyle(
                    title: "Избранные NFT",
                    backButtonHidden: false,
                    filterButtonHidden: true,
                    filterButtonTapHandler: {}
                ))
        }
        .navigationBarBackButtonHidden(true)
    }
    

}

#Preview {

}
