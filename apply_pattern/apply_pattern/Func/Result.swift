//
//  Result.swift
//  apply_pattern
//
//  Created by Moonbeom KWON on 2023/11/16.
//

import Combine
import UIKit

enum DefinedError: Error {
    case noData
    case noImage
}

extension Result {
    func fold(success: (Success) -> Void, failure: (Failure) -> Void) {
        switch self {
            case .success(let value):
                success(value)
            case .failure(let error):
                failure(error)
        }
    }
}

extension URLRequest {
    func loadData() async -> Result<Data, Error> {
        return await withCheckedContinuation { continuation in
            URLSession.shared.dataTask(with: self) { data, _, error in
                if let error = error {
                    continuation.resume(returning: .failure(error))
                } else if let data = data {
                    continuation.resume(returning: .success(data))
                } else {
                    continuation.resume(returning: .failure(DefinedError.noData))
                }
            }.resume()
        }
    }
}

extension UIImage {
    static func makeImage(fromData data: Data) -> Result<UIImage, Error> {
        if let image = UIImage(data: data) {
            return .success(image)
        } else {
            return .failure(DefinedError.noImage)
        }
    }
}
