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
    // memo.id와 같은 id 속성을 가진 메모를 찾습니다. firstIndex(where:) 함수는 클로저 조건을 충족하는 첫 번째 요소의 인덱스를 반환합니다.
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
    
    // 커스텀 네비바를 뷰모델에서 구현
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
    
    // 메모 눌렀을때 일어날 동작 처리
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
            // memo를 삭제할 조건을 작성
            removeMemos.contains(memo)
        }
        removeMemos.removeAll()
        isEditMemoMode = false
    }
    /*
     memos.removeAll { memo in ... }: memos 배열에서 조건을 충족하는 모든 요소를 제거합니다. 여기서 클로저는 memo라는 이름의 각 메모에 대해 실행됩니다. 클로저의 반환 값이 true인 경우에만 해당 메모가 제거됩니다.

     removeMemos.contains(memo): removeMemos라는 다른 배열에 포함된 메모만 제거 대상으로 고려됩니다. 이 배열은 어떤 메모가 삭제되어야 하는지를 추적하기 위해 사용됩니다. 즉, removeMemos에 속한 메모들만이 실제로 삭제됩니다.

     removeMemos.removeAll(): 삭제 대상으로 지정된 메모를 모두 삭제한 후, removeMemos 배열을 비웁니다. 이렇게 하면 다음 삭제 작업을 위해 준비된 상태가 됩니다.

     isEditMemoMode = false: 마지막으로, isEditMemoMode 변수를 false로 설정하여 편집 모드를 비활성화합니다. 이 변수는 삭제 버튼을 탭한 후 편집 모드를 해제하는 데 사용됩니다.
     */
}
