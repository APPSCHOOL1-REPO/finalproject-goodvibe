//
//  MyPageView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var userVM: UserViewModel
    
    
    @State private var isSheetPresented: Bool = false
    @State private var isUpdateUserInfoPresented: Bool = false
    @State private var isMyReviewPresented: Bool = false
    @State private var isShowingAlert: Bool = false
    
    @State private var isShowingNotice: Bool = false
    @State private var isShowingTerms: Bool = false

    
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .leading){
                Text("마이페이지")
                    .font(.largeTitle)
                    .padding(.top, 20)
                    .padding()
            
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
                                    Text("\(userVM.userInfo.userNickname)")
                                        .font(.title3)
                                    
                                    Spacer()

                                    Text("\(userVM.userInfo.status)님")
                                        .font(.body)
                                        .padding(.trailing, 20)
                                }
                                .padding(.leading, 10)
                                .padding(.bottom, 1)
                                
                                HStack{
                                    Text(userVM.userInfo.userEmail)
                                        .font(.caption)
                                        .padding(.leading, 10)
                                }
                            }
                            
                        }
                    }
                    .padding()


                
                VStack (alignment: .leading, spacing: 25) {
                    //공지사항도 있어야할것같아서 버튼만 우선 만들었습니다.
                    Button {
                        self.isShowingNotice.toggle()
                    } label: {
                        HStack{
                            Image(systemName: "exclamationmark.bubble")
                            Text("공지")
                        }
                    }
                    .fullScreenCover(isPresented: $isShowingNotice) {
                        NoticeView()
                    }
                    
                    
                    Button {
                        self.isMyReviewPresented.toggle()
                    } label: {
                        HStack{
                            Image(systemName: "pencil")
                            Text("내가 쓴 리뷰보기")
                        }
                    }
                    .fullScreenCover(isPresented: $isMyReviewPresented) {
                        MyReviewView()
                            .environmentObject(ReviewViewModel())
                            .environmentObject(UserViewModel())
                    }
                    
                    Button {
                        self.isUpdateUserInfoPresented.toggle()
                    } label: {
                        HStack{
                            Image(systemName: "gearshape.fill")
                            Text("회원정보수정")
                        }
                    }
                    .fullScreenCover(isPresented: $isUpdateUserInfoPresented) {
                        UpdateUserInfoView()
                            .environmentObject(UserViewModel())
                        
                    }
                    
                    Button {
                        userVM.isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
                            userVM.signOut()
                        }
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5){
                            userVM.isLoading = false
                        }
                    } label: {
                        HStack{
                            Image(systemName: "paperplane.fill")
                            Text("로그아웃")
                        }
                    }
                    Button {
                        isSheetPresented.toggle()
                    } label: {
                        HStack{
                            Image(systemName: "lock.open.fill")
                            Text("장소 제보하기(임시)")
                        }
                    }
                    
                    //이용약관 페이지로 넘어가는 버튼
                    Button {
                        self.isShowingTerms.toggle()
                    } label: {
                        HStack{
                            Image(systemName: "captions.bubble")
                            Text("약관 및 정책")
                        }
                    }
                    .fullScreenCover(isPresented: $isShowingTerms) {
                        PolicyView()
                    }
                    
                    
                    Button {
                        isShowingAlert.toggle()
                    } label: {
                        Image(systemName: "xmark.circle")
                        Text("회원탈퇴")
                            .foregroundColor(.red)
                    }
                    .alert("회원탈퇴", isPresented: $isShowingAlert) {
                        Button("확인", role: .cancel) {
                            userVM.deleteUser()
                        }
                        Button("취소", role: .destructive) {
                            
                        }
                    } message: {
                        Text("사용자의 정보가 즉시 삭제됩니다. \n 회원탈퇴를 진행하시겠습니까?")
                    }
                    
                }
                .foregroundColor(.black)
                .padding()
                .padding(.top, 5)
                .font(.title3)
            }
            
            
            Spacer()
        }
        .onAppear {
            userVM.fetchUpdateUserInfo()
        }
        .overlay(content: {
            LoadingView(show: $userVM.isLoading)
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
