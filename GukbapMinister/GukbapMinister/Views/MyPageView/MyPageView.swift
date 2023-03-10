//
//  MyPageView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct MyPageView: View {
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var storesViewModel: StoresViewModel
    @StateObject private var reviewViewModel = ReviewViewModel()

    @State private var isSheetPresented: Bool = false
    @State private var isUpdateUserInfoPresented: Bool = false
    @State private var isMyReviewPresented: Bool = false
    
    @State private var isShowingNotice: Bool = false
    @State private var isShowingTerms: Bool = false
    var checkAllMyReviewCount : [Review] {
        reviewViewModel.reviews.filter{
            $0.userId == userViewModel.userInfo.id
        }
    }
    var body: some View {
        NavigationStack {
            // 로그아웃 상태가 아니면(로그인상태이면) mypageView 띄우기
            if userViewModel.isLoggedIn != false {
            VStack(alignment: .leading){
           
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(.gray.opacity(0.1))
                    .frame(width: UIScreen.main.bounds.width - 30, height: 110)
                    .cornerRadius(20)
                    .overlay{
                        HStack(alignment: .center){
                            
                            Circle()
                                .fill(.gray.opacity(0.2))
                                .frame(width: 75, height: 75)
                                .overlay{
                                    Image("Ddukbaegi.fill")
                                        .foregroundColor(.accentColor)      // 뚝배기(임시) 계급 색깔 = 브론즈, 실버, 골드
                                        .font(.largeTitle)
                                }
                                .padding(.leading, 20)
                            
                            VStack(alignment: .leading){
                                HStack{
                                    Text("\(userViewModel.userInfo.userNickname)")
                                        .font(.title3)
                                    
                    
                                    switch userViewModel.loginState{
                                    case .kakaoLogin :
                                        Image("KakaoLogin")
                                            .resizable()
                                            .frame(width: UIScreen.main.bounds.width * 0.052, height: UIScreen.main.bounds.height * 0.025)
                                    
                                    case .googleLogin :
                                        Image("GoogleLogin")
                                            .resizable()
                                            .frame(width: UIScreen.main.bounds.width * 0.052, height: UIScreen.main.bounds.height * 0.025)

                                    case .appleLogin :
                                        Image("AppleLogin")
                                            .resizable()
                                            .frame(width: UIScreen.main.bounds.width * 0.052, height: UIScreen.main.bounds.height * 0.025)

                                    case .logout : Text("")
                                        
                                    }
                                    
                                    Spacer()
                                    
                                    Text("\(userViewModel.userInfo.userGrade)님")
                                        .font(.body)
                                        .padding(.trailing, 20)
                                }
                                .padding(.leading, 10)
                                .padding(.bottom, 1)
                                
                                HStack{
                                    Text(userViewModel.userInfo.userEmail)
                                        .font(.caption)
                                        .padding(.leading, 10)
                                }
                            }
                            
                        }
                    }
                    .padding()
                
                
//                VStack {
                    List {
                        
                        NavigationLink {
                            NoticeView()
                        } label: {
                            HStack {
                                Image(systemName: "exclamationmark.bubble")
                                Text("공지")
                            }
                        }
                        .listRowSeparator(.hidden)

                        
                        NavigationLink {
                            MyReviewView()
                                .environmentObject(storesViewModel)

                        } label: {
                            HStack {
                                Image(systemName: "pencil")
                                Text("내가 쓴 리뷰")
                                Spacer()
                                Text("\(checkAllMyReviewCount.count)")
                            }
                        }
                        .listRowSeparator(.hidden)

                        
                        NavigationLink {
                            UpdateUserInfoView()
                        } label: {
                            HStack {
                                Image(systemName: "gearshape.fill")
                                Text("회원정보 수정")
                            }
                        }
                        .listRowSeparator(.hidden)

                        
                        // 서포터즈에게만 열리고(국밥부차관), 나머지 사람들한테는 클릭했을 때 서포터즈에 지원하세요라는 홍보 문구, 위도 경도 임시 부분을 geocoding (주소만입력하면 자동으로 위도경도 기입), Store컬렉션으로 바로 들어가는데 Store_Temp 만들어서 관리자앱에서 관리할 수 있게.
                        NavigationLink {
                            //  if 유저등급 == 국밥부차관등급 { RegisterStoreView  열림}
                            // else  {국밥부 차관에 지원하세요  alert (확인버튼만 우선 구현)}
                        } label: {
                            HStack {
                                Image(systemName: "lock.open.fill")
                                Text("새로운 국밥집 등록하기")
                            }
                        }
                        .listRowSeparator(.hidden)

                        
                        
                        NavigationLink {
                            PolicyView()
                        } label: {
                            HStack {
                                Image(systemName: "captions.bubble")
                                Text("앱정보")
                            }
                        }
                        
                        Button {
                            userViewModel.logoutByPlatform()

                            // userVM.isLoading = true
                            // DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
                            //     userVM.signOut()
                            // }
                            // DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5){
                            //     userVM.isLoading = false
                            // }
                        } label: {
                            HStack{
                                Image(systemName: "xmark.circle")
                                Text("로그아웃")
                            }
                        }
//                        .foregroundColor(.black)
                        .padding(1.5)
                        
                        //                        .listRowInsets(EdgeInsets.init(top: 5, leading: 5, bottom: 5, trailing: 5))
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)

//                }
                
            }
            .navigationTitle("마이페이지")
            .navigationBarTitleDisplayMode(.inline)

                Spacer()
                Text("\(userViewModel.userInfo.userGrade)")
                Text("\(userViewModel.userInfo.userEmail)")
                Text("\(userViewModel.userInfo.id)")
            } else {
                goLoginView()
                    .environmentObject(userViewModel)
            }
            
        }
        .onAppear {
//            userVM.fetchUpdateUserInfo()
            reviewViewModel.fetchAllReviews()
        }
        .overlay(content: {
//            LoadingView(show: $userVM.isLoading)
        })
        .sheet(isPresented: $isSheetPresented) {
            NavigationStack {
                StoreRegistrationView(isOn: $isSheetPresented)
            }
            .tint(.mainColor)
        }
        .tint(.mainColor)
        
        
    }
}

// >>>>>>>>>>필독<<<<<<<<<< 프리뷰 써야하면 37번째 줄 .overlay부분 주석 시키기!!!!!! 문의->서현
//struct MyPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageView()
//    }
//}
