//
//  Path.swift
//  voiceMemo
//

import Foundation

class PathModel: ObservableObject {
  @Published var paths: [PathType]
  
    // 일단 빈경로를 만들어서 모델을 생성 
  init(paths: [PathType] = []) {
    self.paths = paths
  }
}
