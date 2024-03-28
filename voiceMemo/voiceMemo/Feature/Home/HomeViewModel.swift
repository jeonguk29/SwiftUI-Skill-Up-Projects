//
//  HomeViewModel.swift
//  voiceMemo
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var selectedTab: Tab // 현재 어떤게 선택되어 있는지
        
    // 설정 View에서 몇개가 보여지는지 보여주기 위함
    @Published var todosCount: Int
    @Published var memosCount: Int
    @Published var voiceRecordersCount: Int
    
    init(
        selectedTab: Tab = .voiceRecorder, // 기본 탭 설정
        todosCount: Int = 0,
        memosCount: Int = 0,
        voiceRecordersCount: Int = 0
    ) {
        self.selectedTab = selectedTab
        self.todosCount = todosCount
        self.memosCount = memosCount
        self.voiceRecordersCount = voiceRecordersCount
    }
}

// 로직 구현
extension HomeViewModel {
    
    // 카운트 값을 바꿔주는 메서드들
    func setTodosCount(_ count: Int) {
        todosCount = count
    }
    
    func setMemosCount(_ count: Int) {
        memosCount = count
    }
    
    func setVoiceRecordersCount(_ count: Int) {
        voiceRecordersCount = count
    }
    
    // 탭 변경 메서드 (설정에서도 사용하기 위함)
    func changeSelectedTab(_ tab: Tab) {
        selectedTab = tab
    }
}
