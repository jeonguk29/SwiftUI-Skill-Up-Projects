//
//  MainTabView.swift
//  LMessenger
//
//  Created by 정정욱 on 4/4/24.
//
import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: MainTabType = .home
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTabType.allCases, id:\.self) { tab in
                Group {
                    switch tab {
                    case .home:
                        HomeView(homeViewModel: .init())
                    case .chat:
                        ChatListView()
                    case .phone:
                        Color.blackFix
                    }
                }
                .tabItem {
                    Label(tab.title, image: tab.imageName(selected: selectedTab == tab))
                }
                .tag(tab)
            }
        }
        .tint(.bkText)
    }
    
    init() {
        // 눌리지 않았을때 색상 변경 로직 
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.bkText)
    }
}

#Preview {
    MainTabView()
}
