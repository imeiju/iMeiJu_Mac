////  IZUtils.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/3.
//	QQ群:	577506623
//	GitHub:	https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Foundation
import Moya

enum MoyaApi {
    case index(vsize: String)
    case show(vid: String)
}

extension MoyaApi : TargetType {

    var baseURL: URL {
        return URL.init(string: "https://mjappaz.yefu365.com")!
    }
    
    var path: String {
        switch self {
        case .index:
            return "/index.php/app/ios/topic/index"
        case .show:
            return "/index.php/app/ios/vod/show"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .index:
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
            return .requestParameters(parameters:["vsize":vsize], encoding: URLEncoding.default)
        case let .show(vid):
            return .requestParameters(parameters: ["id":vid], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Accept": "*/*","Accept-Encoding": "br, gzip, deflate","Accept-Language": "en-CN;q=1, zh-Hans-CN;q=0.9","Connection": "keep-alive","Content-Type": "application/x-www-form-urlencoded;charset=utf8","Host": "mjappaz.yefu365.com","User-Agent": "XMFilmTelevision/1.4 (iPhone; iOS 12.1.3; Scale/3.00)"]
    }
    
    
}
