//
//  MemoListViewModel.swift
//  voiceMemo
//

import Foundation

class MemoListViewModel: ObservableObject {
    @Published var memos: [Memo]
    @Published var isEditMemoMode: Bool // 편집 하는 화면과 그렇지 않은 화면
    @Published var removeMemos: [Memo] // 식제 메모들
    @Published var isDisplayRemoveMemoAlert: Bool
    
    var removeMemoCount: Int {
        return removeMemos.count
    }
    var navigationBarRightBtnMode: NavigationBtnType {
        isEditMemoMode ? .complete : .edit
    }
    
    init(
        memos: [Memo] = [],
        isEditMemoMode: Bool = false,
        removeMemos: [Memo] = [],
        isDisplayRemoveMemoAlert: Bool = false
    ) {
        self.memos = memos
        self.isEditMemoMode = isEditMemoMode
        self.removeMemos = removeMemos
        self.isDisplayRemoveMemoAlert = isDisplayRemoveMemoAlert
    }
}

extension MemoListViewModel {
    
    // 메모 추가
    func addMemo(_ memo: Memo) {
        memos.append(memo)
    }
    
    // 메모 수정
    func updateMemo(_ memo: Memo) {
        if let index = memos.firstIndex(where: { $0.id == memo.id }) {
            memos[index] = memo
        }
    }
    
    // 메모 삭제
    func removeMemo(_ memo: Memo) {
        if let index = memos.firstIndex(where: { $0.id == memo.id }) {
            memos.remove(at: index)
        }
    }
    
    func navigationRightBtnTapped() {
        if isEditMemoMode {
            if removeMemos.isEmpty {
                isEditMemoMode = false
            } else {
                // 삭제 얼엇 상태값 변경을 위한 메서드 호출
                setIsDisplayRemoveMemoAlert(true)
            }
        } else {
            isEditMemoMode = true
        }
    }
    
    func setIsDisplayRemoveMemoAlert(_ isDisplay: Bool) {
        isDisplayRemoveMemoAlert = isDisplay
    }
    
    // 메모 삭제 눌렀을때 일어날 동작 처리
    func memoRemoveSelectedBoxTapped(_ memo: Memo) {
        if let index = removeMemos.firstIndex(of: memo) {
            removeMemos.remove(at: index) // 원래 체크 되어 있었으면 빠지게
        } else {
            removeMemos.append(memo) // 선택 되면 삭제 리스트에 넣기
        }
    }
    
    // 모든 메모 지우기   
    func removeBtnTapped() {
        memos.removeAll { memo in
            removeMemos.contains(memo)
        }
        removeMemos.removeAll()
        isEditMemoMode = false
    }
}
