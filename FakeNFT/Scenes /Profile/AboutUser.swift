//
//  AboutUser.swift
//  FakeNFT
//
//  Created by Mac on 17.06.2025.
//

import SwiftUI

struct AboutUser: View {
    var body: some View {
        NavigationView{
            VStack{
              
            }  .modifier(NavigationBarStyle(
                title: "О разработчике",
                backButtonHidden: false,
                filterButtonHidden: true,
                filterButtonTapHandler: {}
            ))
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AboutUser()
}
