////  Network.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/3.
//	QQ群:	577506623
//	GitHub:	https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Foundation

let provider = MoyaProvider<MoyaApi>()

enum MoyaApi {
    case index(vsize: String)
    case movie(id: String, vsize: String)
    case more(page: String, size: String, ztid: String)
    case movieMore(page: String, size: String, id: String)
    case search(key: String, page: String, size: String)
    case show(id: String)
}

extension MoyaApi: TargetType {
    var baseURL: URL {
        return URL(string: "https://mjappaz.yefu365.com")!
    }

    var path: String {
        switch self {
        case .index:
            return "/index.php/app/ios/topic/index"
        case .movie:
            return "/index.php/app/ios/type/index"
        case .movieMore:
            return "/index.php/app/ios/vod/index"
        case .more:
            return "/index.php/app/ios/vod/index"
        case .search:
            return "/index.php/app/ios/vod/index"
        case .show:
            return "/index.php/app/ios/vod/show"
        }
    }

    var method: Moya.Method {
        switch self {
        case .index:
            return .get
        case .movie:
            return .get
        case .more:
            return .get
        case .movieMore:
            return .get
        case .search:
            return .get
        case .show:
            return .get
        }
    }

    var sampleData: Data {
        return Data(base64Encoded: "just for test")!
    }

    var task: Task {
        switch self {
        case let .index(vsize):
            return .requestParameters(parameters: ["vsize": vsize], encoding: URLEncoding.default)
        case let .movie(id, vsize):
            return .requestParameters(parameters: ["id": id, "vsize": vsize], encoding: URLEncoding.default)
        case let .more(page, size, ztid):
            return .requestParameters(parameters: ["page": page, "size": size, "ztid": ztid], encoding: URLEncoding.default)
        case let .movieMore(page, size, id):
            return .requestParameters(parameters: ["page": page, "size": size, "id": id], encoding: URLEncoding.default)
        case let .search(key, page, size):
            return .requestParameters(parameters: ["key": key, "page": page, "size": size], encoding: URLEncoding.default)
        case let .show(id):
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return [
            "Accept": "*/*",
            "Accept-Encoding": "br, gzip, deflate",
            "Accept-Language": "en-CN;q=1, zh-Hans-CN;q=0.9",
            "Connection": "keep-alive",
            "Content-Type": "application/x-www-form-urlencoded;charset=utf8",
            "Host": "mjappaz.yefu365.com",
        ]
    }
}
