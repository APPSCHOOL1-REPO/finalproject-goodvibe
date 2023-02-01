//
//  ExploreView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var storeViewModel: StoreViewModel = StoreViewModel()
    @StateObject var storesViewModel: StoresViewModel = StoresViewModel()
   
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State var searchGukBap : String = ""
    @State var isPresentedSearchView: Bool = false
    
    let titles: [String] = ["조회수순", "평점순"]
    @State private var selectedIndex: Int = 0
    
    var body: some View {

        NavigationStack{
            ScrollView {
                VStack{
                    search
                    
                    HStack {
                        SegmentedPicker(
                            titles,
                            selectedIndex: Binding(
                                get: { selectedIndex },
                                set: { selectedIndex = $0 ?? 0 }),
                            content: { item, isSelected in
                                Text(item)
                                    .foregroundColor(isSelected ? Color.black : Color.gray )
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                            },
                            selection: {
                                VStack(spacing: 0) {
                                    Spacer()
                                    Rectangle()
                                        .fill(Color.black)
                                        .frame(height: 1)
                                }
                            })
                        
                        .animation(.easeInOut(duration:0.3))
                    }
                    .frame(height: 70)
                    ForEach(storesViewModel.stores, id: \.self){ store2 in
                        NavigationLink{
                            DetailView()
                        } label:{
                            StoreView(store:store2, storeViewModel: storeViewModel)
                        }
                    }
                    //ForEach
                }
                //VStack
                
                
            }
        }
        .onAppear {
            storesViewModel.subscribeStores()
            print("\(storesViewModel.stores)")
          
        }
        .onDisappear {
            storesViewModel.unsubscribeStores()
        }
        }
}//ExploreView
    



extension ExploreView {
    var search: some View {
      HStack{
        VStack {
          HStack {
            Image(systemName: "magnifyingglass")
              .foregroundColor(.secondary)
              .padding(.leading, 15)
            TextField("국밥집 검색",text: $searchGukBap)
              .onTapGesture {
                self.isPresentedSearchView.toggle()
                UIView.setAnimationsEnabled(false)
              }
              .fullScreenCover(isPresented: $isPresentedSearchView) {
                SearchView()
              }
              .onAppear {
                UIView.setAnimationsEnabled(true)
              }
            
          }
          .frame(width: 280, height: 50)
          .background(Capsule().fill(Color.white))
          .overlay {
            Capsule()
              .stroke(.yellow)
          }
        }
      }
      .padding(.horizontal,18)
    }
}
