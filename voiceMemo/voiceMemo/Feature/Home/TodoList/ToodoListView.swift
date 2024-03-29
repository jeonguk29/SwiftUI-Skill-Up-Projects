//
//  ToodoListView.swift
//  voiceMemo
//

import SwiftUI

struct TodoListView: View {
    
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel // TodoView와 전역적으로 상태를 공유하기 위함
    
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    
    var body: some View {
        // 3번째 방법 이것도 디자인 시스템으로 많이 활용됨
        WriteBtnView {
            // 투두 셀 리스트
            VStack {
                if !todoListViewModel.todos.isEmpty {
                    CustomNavigationBar(
                        isDisplayLeftBtn: false,
                        rightBtnAction: {
                            // 뷰모델에서 만든 메서드를 전달
                            todoListViewModel.navigationRightBtnTapped()
                        },
                        rightBtnType: todoListViewModel.navigationBarRightBtnMode
                    )
                } else {
                    Spacer()
                        .frame(height: 30)
                }
                
                TitleView()
                    .padding(.top, 20)
                
                if todoListViewModel.todos.isEmpty {
                    AnnouncementView()
                } else {
                    TodoListContentView()
                        .padding(.top, 20)
                }
            }
        } action: {
            pathModel.paths.append(.todoView)
        }

        
        //.modifier(WriteBtnViewModifier(action: {pathModel.paths.append(.todoView)}))
        // 기존 작성 버튼의 액션을 넘겨줌
//        .writeBtn {
//            pathModel.paths.append(.todoView) // 두번째 방법 더 단순해짐 (이걸 선호함)
//        }
        .alert(
            "To do list \(todoListViewModel.removeTodosCount)개 삭제하시겠습니까?",
            isPresented: $todoListViewModel.isDisplayRemoveTodoAlert
        ) {
            Button("삭제", role: .destructive) {
                todoListViewModel.removeBtnTapped()
            }
            Button("취소", role: .cancel) { }
        }
        .onChange(
            // of 안에 값이 변하면 perform으로 동작실행 가능
            of: todoListViewModel.todos,
            perform: { todos in
                homeViewModel.setTodosCount(todos.count)
            }
        )
        // 이렇게 하면 실시간으로 todo 변경될때 마다 셋팅에서 바인딩 시킨 todo개수 알 수 있음
    }
    
    
    
    //    func titleView() -> some View {
    //        Text("Title")
    //    }
    //이렇게 사용하면 해당 뷰에서만 사용해서 따로 분리해서 사용하는게 좀더 재사용성이 좋음 다른 파일에서도 불러올 수 있고
}



// MARK: - TodoList 타이틀 뷰
private struct TitleView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        HStack {
            if todoListViewModel.todos.isEmpty {
                Text("To do list를\n추가해 보세요.")
            } else {
                Text("To do list \(todoListViewModel.todos.count)개가\n있습니다.")
            }
            
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}


// MARK: - TodoList 안내 뷰 (todo가 없을때 보여줄 뷰)
private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            Image("pencil")
                .renderingMode(.template)
            Text("\"매일 아침 5시 운동하자!\"")
            Text("\"내일 8시 수강 신청하자!\"")
            Text("\"1시 반 점심약속 리마인드 해보자!\"")
            
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundColor(.customGray2)
    }
}


// MARK: - TodoList 컨텐츠 뷰 (todo가 있을때 보여줄 View)
private struct TodoListContentView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Text("할일 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)
                
                Spacer()
            }
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Rectangle() // 구분선 역할
                        .fill(Color.customGray0)
                        .frame(height: 1)
                    
                    ForEach(todoListViewModel.todos, id: \.self) { todo in
                        TodoCellView(todo: todo)
                    }
                }
            }
        }
    }
}




// MARK: - Todo 셀 뷰
private struct TodoCellView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @State private var isRemoveSelected: Bool // 삭제될때 체크 값
    private var todo: Todo
    
    fileprivate init(
        isRemoveSelected: Bool = false,
        todo: Todo
    ) {
        _isRemoveSelected = State(initialValue: isRemoveSelected)
        self.todo = todo
    }
    
    fileprivate var body: some View {
        VStack(spacing: 20) {
            HStack {
                if !todoListViewModel.isEditTodoMode {
                    Button(
                        action: { todoListViewModel.selectedBoxTapped(todo) },
                        label: { todo.selected ? Image("selectedBox") : Image("unSelectedBox") }
                    )
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(todo.title)
                        .font(.system(size: 16))
                        .foregroundColor(todo.selected ? .customIconGray : .customBlack)
                        .strikethrough(todo.selected)
                    
                    Text(todo.convertedDayAndTime)
                        .font(.system(size: 16))
                        .foregroundColor(.customIconGray)
                }
                
                Spacer()
                
                if todoListViewModel.isEditTodoMode {
                    // 편집 모드일때
                    Button(
                        action: {
                            isRemoveSelected.toggle()
                            todoListViewModel.todoRemoveSelectedBoxTapped(todo)
                        },
                        label: {
                            isRemoveSelected ? Image("selectedBox") : Image("unSelectedBox")
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
        }
    }
}



// MARK: - Todo 작성 버튼 뷰
private struct WriteTodoBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(
                    action: {
                        pathModel.paths.append(.todoView)// todoView로 이동
                    },
                    label: {
                        Image("writeBtn")
                    }
                )
            }
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}
