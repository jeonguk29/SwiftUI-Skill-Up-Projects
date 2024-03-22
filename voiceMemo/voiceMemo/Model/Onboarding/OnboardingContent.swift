//
//  OnboardingContent.swift
//  voiceMemo
//

import Foundation

// 온보딩도 재활용이 크기 때문에 모델로 만들어 관리 
// Hashable를 채택하는 이유는 각각의 모델을 만들때 고유하게 만들기 위해서임 
struct OnboardingContent: Hashable {
  var imageFileName: String
  var title: String
  var subTitle: String
  
  init(
    imageFileName: String,
    title: String,
    subTitle: String
  ) {
    self.imageFileName = imageFileName
    self.title = title
    self.subTitle = subTitle
  }
}
