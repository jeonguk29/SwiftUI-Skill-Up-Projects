//
//  MemoListView.swift
//  voiceMemo
//

import SwiftUI

struct MemoListView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    // 전역적으로 상태 공유하고 사용하기 위해 @EnvironmentObject를 사용
    
    var body: some View {
        ZStack {
            VStack {
                if !memoListViewModel.memos.isEmpty {
                    // 비어 있을때는 위로가기 필요 없음, 오른쪽 메모 생성하기 버튼 만들기
                    CustomNavigationBar(
                        isDisplayLeftBtn: false,
                        rightBtnAction: {
                            memoListViewModel.navigationRightBtnTapped()
                        },
                        rightBtnType: memoListViewModel.navigationBarRightBtnMode
                    )
                } else {
                    Spacer()
                        .frame(height: 30)
                }
                
                TitleView()
                    .padding(.top, 20)
                
                if memoListViewModel.memos.isEmpty {
                    AnnouncementView()
                } else {
                    MemoListContentView()
                        .padding(.top, 20)
                }
            }
            
            WriteMemoBtnView()
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .alert( 
            "메모 \(memoListViewModel.removeMemoCount)개 삭제하시겠습니까?",
            isPresented: $memoListViewModel.isDisplayRemoveMemoAlert
        ) {
            Button("삭제", role: .destructive) {
                memoListViewModel.removeBtnTapped()
            }
            Button("취소", role: .cancel) { }
        }
        
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    fileprivate var body: some View {
        HStack {
            if memoListViewModel.memos.isEmpty {
                Text("메모를\n추가해 보세요.")
            } else {
                Text("메모 \(memoListViewModel.memos.count)개가\n있습니다.")
            }
            
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - 안내 뷰
private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            Image("pencil")
                .renderingMode(.template) // 💁 색상, 사이즈 변경 가능해짐
            Text("\"퇴근 9시간전 메모\"")
            Text("\"개발 끝낸 후 퇴근하기!\"")
            Text("\"밀린 알고리즘 공부하기!!\"")
            
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundColor(.customGray2)
    }
}

// MARK: - 메모 리스트 컨텐츠 뷰
private struct MemoListContentView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Text("메모 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)
                
                Spacer()
            }
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Rectangle() // 구분선
                        .fill(Color.customGray0)
                        .frame(height: 1)
                    
                    ForEach(memoListViewModel.memos, id: \.self) { memo in
                        MemoCellView(memo: memo)
                    }
                }
            }
        }
    }
}

private struct MemoCellView: View {
    @EnvironmentObject private var pathModel: PathModel //메모 눌릴때 화면 이동해야 해서
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @State private var isRemoveSelected: Bool
    private var memo: Memo
    
    fileprivate init(
        isRemoveSelected: Bool = false,
        memo: Memo
    ) {
        _isRemoveSelected = State(initialValue: isRemoveSelected)
        self.memo = memo
    }
    
    fileprivate var body: some View {
        Button( // 이동해야하기 때문에 버튼으로 구성해줌
            action: {
                // 메모를 보는 모드로 즉 수정 모드로 볼거야
                pathModel.paths.append(.memoView(isCreatMode: false, memo: memo))
            },
            label: {
                VStack(spacing: 10) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(memo.title)
                                .lineLimit(1)
                                .font(.system(size: 16))
                                .foregroundColor(.customBlack)
                            
                            Text(memo.convertedDate)
                                .font(.system(size: 12))
                                .foregroundColor(.customIconGray)
                        }
                        
                        Spacer()
                        
                        // 수정 모드일때 선택이나 삭제가 가능하도록
                        if memoListViewModel.isEditMemoMode {
                            Button(
                                action: {
                                    isRemoveSelected.toggle()
                                    memoListViewModel.memoRemoveSelectedBoxTapped(memo)
                                },
                                label: { isRemoveSelected ? Image("selectedBox") : Image("unSelectedBox") }
                            )
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 10)
                    
                    Rectangle() // 구분선
                        .fill(Color.customGray0)
                        .frame(height: 1)
                }
            }
        )
    }
}

// MARK: - 메모 작성 버튼 뷰
private struct WriteMemoBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(
                    action: {
                        pathModel.paths.append(.memoView(isCreatMode: true, memo: nil)) // 처음 생성할때는 없을거니까 메모 nil
                    },
                    label: {
                        Image("writeBtn")
                    }
                )
            }
        }
    }
}

struct MemoListView_Previews: PreviewProvider {
    static var previews: some View {
        MemoListView()
            .environmentObject(PathModel())
            .environmentObject(MemoListViewModel())
    }
}
