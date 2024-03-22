//
//  OnboardingContent.swift
//  voiceMemo
//

import Foundation

// 온보딩도 재활용이 크기 때문에 모델로 만들어 관리 
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
