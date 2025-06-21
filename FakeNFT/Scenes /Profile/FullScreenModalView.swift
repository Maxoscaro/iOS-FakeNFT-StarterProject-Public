//
//  FullScreenModalView.swift
//  FakeNFT
//
//  Created by Mac on 14.06.2025.
//

import SwiftUI
import PhotosUI
struct FullScreenModalView: View {
   

    @Environment(\.presentationMode) var presentationMode
   
    var viewModel: FullSrceenModalViewModel
   
    var body: some View {
        HStack{
            Spacer()
            Button("", systemImage: "xmark") {
                UserDefaults.standard.set(viewModel.model.description, forKey: "description")
                UserDefaults.standard.set(viewModel.model.name, forKey: "name")
                UserDefaults.standard.set(link, forKey: "link")
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundStyle(Color.blackDay)
            .frame(width: 45, height: 45)
            .font(.system(size: 19, weight: .bold))
            
        }
        VStack(spacing: 20){
            ZStack(alignment: .center){
                if let data = viewModel.imageData, let uiImage = UIImage(data: data){
                    PhotosPicker(selection: viewModel.$selectedItem, matching: .images)
                    {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120,height: 120)
                            .frame(width: 70, height: 70)
                            .clipShape(.circle)
                        }.padding()
                        
                        
                    
                }
                Text("Сменить \nфото")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 10, weight: .semibold))
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .frame(width: 100, height: 100, alignment: .center)
            }
            
           
            
            
        }
        .navigationTitle("Выбор изображения")
        .onChange(of: viewModel.selectedItem ?? nil) { newItem in
            Task{
                if let data = try? await newItem?.loadTransferable(type: Data.self){
                    viewModel.imageData = data
                }
            }
            
        }
        
        VStack(alignment: .leading){

           
            
            Text("Имя")
                .font(.bold22)
                .foregroundColor(Color.blackDay)
                .padding(.leading)
            ZStack{
                TextField(viewModel.model.name, text: viewModel.model.$name)
                     .padding()
                     .background(Color.gray.opacity(0.1))
                     .cornerRadius(8)
            }.padding(.leading)
             .padding(.trailing)
            
            Text("Описание")
                .font(.bold22)
                .foregroundColor(Color.blackDay)
                .padding(.leading)
            ZStack{
                TextField(viewModel.model.description, text: viewModel.model.$description)
                     .padding()
                     .background(Color.gray.opacity(0.1))
                     .cornerRadius(8)
            }.padding(.leading)
             .padding(.trailing)
            
            Text("Ссылка")
                .font(.bold22)
                .foregroundColor(Color.blackDay)
                .padding(.leading)
            ZStack{
                TextField(viewModel.link, text: viewModel.$link)
                     .padding()
                     .background(Color.gray.opacity(0.1))
                     .cornerRadius(8)
            }.padding(.leading)
             .padding(.trailing)
            
            
    
            
            Spacer()

        }
        
       
    }
}

#Preview {
    FullScreenModalView(viewModel: FullSrceenModalViewModel.init(model: FullScreenModalModel.init(name: "", description: "", link: "")))
}
