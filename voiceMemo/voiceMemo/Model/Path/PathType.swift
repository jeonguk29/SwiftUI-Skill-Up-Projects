//
//  PathType.swift
//  voiceMemo
//

// 네비게이션 스택으로 갈 수 있는 경로를 만들어주기 
enum PathType: Hashable {
  case homeView
  case todoView
  case memoView(isCreatMode: Bool, memo: Memo?) // 생성모드이면 생성 아니면 편집모드 View를 보여주기 위함 
}
/*
 Hashable 프로토콜은 열거형을 집합(Set)이나 딕셔너리(Dictionary)의 키로 사용하기 위해 필요합니다. 네비게이션 스택은 일종의 데이터 구조이며, 특정한 뷰를 식별하기 위해서는 해당 뷰의 타입을 키로 사용해야 합니다. 따라서 PathType 열거형은 Hashable 프로토콜을 채택하여 이러한 요구사항을 충족시킵니다.
 */
