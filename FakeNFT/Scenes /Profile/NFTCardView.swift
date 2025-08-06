//
//  NFTCardView.swift
//  FakeNFT
//
//  Created by Mac on 16.07.2025.
//

import SwiftUI

struct NFTCardView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    
    let nft: Nft
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .topTrailing){
                if let url = URL(string: nft.images.first ?? "") {
                    AsyncImage(url: url) { image in
                        image.image?.resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(width: 108, height: 108)
                    }
                }
                // Временное изображение-заглушка
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 108, height: 108)
                Button(action: {
                    viewModel.toggleLike(for: nft)
                }) {
                    Image(systemName:"heart.fill")
                       .foregroundColor(viewModel.isLiked(nft) ? .red : .white)
                        .padding(8)
                }
                .buttonStyle(.plain)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(nft.name)
                    .font(.headline)
                    .lineLimit(2)

                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < nft.rating ? "star.fill" : "star")
                            .foregroundColor(.yaYellowUniversal)
                            .font(.caption)
                    }
                }

                Text("от Jhon Doe")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Цена")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(nft.price, specifier: "%.2f") ETH")
                    .font(.headline)
            }
        }
        .padding()
        .background(Color(.systemBackground))
       
    }
        
}

#Preview {

}
