//
//  FavouriteNft.swift
//  FakeNFT
//
//  Created by Mac on 19.06.2025.
//

import SwiftUI

struct FavouriteNft: View {
    
    
    // MARK: - Properties
    @EnvironmentObject var viewModel: ProfileViewModel
    
    let nft: Nft
    
    // MARK: - Content
    
    var body: some View {
        HStack(spacing: 8) {
            ZStack(alignment: .topTrailing){
                if let url = URL(string: nft.images.first ?? ""){
                    AsyncImage(url: url) { image in
                        image.image?.resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(width: 80, height: 80)
                    }
                }
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 80)
                Button(action: {
                    viewModel.toggleLike(for: nft)
                }) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(viewModel.isLiked(nft) ? .red : .white)
                        .padding(6)
                }
                .buttonStyle(.plain)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(nft.name)")
                    .font(.custom("SFProText-Bold", size: 17))
                    .lineLimit(2)
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < nft.rating ? "star.fill" : "star")
                            .foregroundColor(.yaYellowUniversal)
                            .font(.caption)
                    }
                }
                Text("\(nft.price, specifier: "%.2f") ETH")
                    .font(.custom("SFProText-Regular", size: 15))
                  
            }
            
            Spacer()
        }
        .background(Color(.systemBackground))
        .padding(.top)
        
     
    }
    
    // MARK: - View

}

#Preview {
    
}
