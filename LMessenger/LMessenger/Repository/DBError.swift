//
//  DBError.swift
//  LMessenger
//
//  Created by 정정욱 on 4/7/24.
//

import Foundation

enum DBError: Error {
    case error(Error)
    case emptyValue
    case invalidatedType
}
