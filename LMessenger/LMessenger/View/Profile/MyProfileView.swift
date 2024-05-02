//
//  MyProfileView.swift
//  LMessenger
//


import SwiftUI

struct MyProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var profileViewModel: MyProfileViewModel
    
    @State private var menuTypes = MyProfileMenuType.allCases
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("profile_bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(edges: .vertical)
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    profileView
                        .padding(.bottom, 16)
                    
                    nameView
                        .padding(.bottom, 26)
                    
                    descriptionView
                    
                    Spacer()
                    
                    menuView
                        .padding(.bottom, 58)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("close")
                    }
                    .padding(.leading, 20)
                    .padding(.top, 50)
                }
            }
            .task {
                // OnAppear가 불리기 직전에 실행
                await profileViewModel.getUser()
            }
        }
    }
    
    var profileView: some View {
        Button {
            // TODO:
        } label: {
            Image("person")
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
        }
    }
    
    var nameView: some View {
        Text(profileViewModel.userInfo?.name ?? "이름")
            .font((.system(size: 24, weight: .bold)))
            .foregroundStyle(Color(.bgWh))
    }
    
    var descriptionView: some View {
        Button {
            profileViewModel.isPresentedDescEditView.toggle()
        } label: {
            Text(profileViewModel.userInfo?.description ?? "상태메시지를 입력해주세요.")
                .font(.system(size: 14))
                .foregroundStyle(Color(.bgWh))
        }// 상태메시지 수정 
        .sheet(isPresented: $profileViewModel.isPresentedDescEditView) {
            MyProfileDescEditView(description: profileViewModel.userInfo?.description ?? "") { willBeDesc in
                Task {
                    await profileViewModel.updateDescription(willBeDesc)
                }
            }
        }
    }
    
    var menuView: some View {
        HStack(alignment: .top, spacing: 27) {
            ForEach($menuTypes, id: \.self) { $menu in
                Button {
                } label: {
                    VStack(alignment: .center) {
                        Image(menu.imageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text(menu.description)
                            .font(.system(size: 10))
                            .foregroundStyle(Color(.bgWh))
                    }
                }
            }
        }
    }
}

//#Preview {
//    MyProfileView(profileViewModel: .init(userId: "user", container: DIContainer(services: StubService())))
//}
