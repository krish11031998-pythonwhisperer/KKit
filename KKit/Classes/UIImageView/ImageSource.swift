//
//  ImageSource.swift
//  KKit
//
//  Created by Krishna Venkatramani on 13/02/2024.
//

import Foundation

public protocol ImageAsset {
    var image: UIImage { get }
}

public enum ImageSource {
    case remote(url: String)
    case local(img: UIImage)
    case asset(asset: ImageAsset)
    case symbol(name: String)
    case none
}

extension ImageSource: Codable {
    
    public init(from decoder: Decoder) throws {
        guard let val = try? decoder.singleValueContainer().decode(String.self) else {
            self = .none
            return
        }
        self = .remote(url: val)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .remote(let url):
            try container.encode(url)
        default:
            break
        }
    }
}

extension ImageSource: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.remote(let urlOne), .remote(let urlTwo)):
            return urlOne == urlTwo
        case (.local(let imgOne), .local(let imgTwo)):
            return imgOne == imgTwo
        case (.asset(let assetOne), .asset(let assetTwo)):
            return assetOne.image == assetTwo.image
        default:
            return false
        }
    }
}

extension ImageSource: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .remote(let url):
            hasher.combine(url)
        case .local(let img):
            hasher.combine(img)
        case .asset(let asset):
            hasher.combine(asset.image)
        case .symbol(let name):
            hasher.combine(name)
        case .none:
            hasher.combine("none")
        }
    }
}
