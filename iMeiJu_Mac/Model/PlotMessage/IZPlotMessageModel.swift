////  IZPlotMessageModel.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/4.
//	QQ群:	577506623
//	GitHub:	https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Foundation

class IZPlotMessageModel: NSObject, NSCoding {
    var code: Int!
    var data: IZPlotMessageData!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        code = json["code"].intValue
        let dataJson = json["data"]
        if !dataJson.isEmpty {
            data = IZPlotMessageData(fromJson: dataJson)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        if code != nil {
            dictionary["code"] = code
        }
        if data != nil {
            dictionary["data"] = data.toDictionary()
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        code = aDecoder.decodeObject(forKey: "code") as? Int
        data = aDecoder.decodeObject(forKey: "data") as? IZPlotMessageData
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder) {
        if code != nil {
            aCoder.encode(code, forKey: "code")
        }
        if data != nil {
            aCoder.encode(data, forKey: "data")
        }
    }
}

class IZPlotMessageData: NSObject, NSCoding {
    var addtime: String!
    var cid: String!
    var cion: String!
    var cname: String!
    var commentCount: Int!
    var daoyan: String!
    var dhits: Int!
    var diqu: String!
    var fid: String!
    var hits: String!
    var id: String!
    var info: String!
    var look: Int!
    var looktime: Int!
    var name: String!
    var pf: String!
    var pic: String!
    var shareurl: String!
    var state: String!
    var text: String!
    var type: String!
    var vip: String!
    var year: String!
    var yuyan: String!
    var zhuyan: String!
    var zu: [Zu]!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        addtime = json["addtime"].stringValue
        cid = json["cid"].stringValue
        cion = json["cion"].stringValue
        cname = json["cname"].stringValue
        commentCount = json["comment_count"].intValue
        daoyan = json["daoyan"].stringValue
        dhits = json["dhits"].intValue
        diqu = json["diqu"].stringValue
        fid = json["fid"].stringValue
        hits = json["hits"].stringValue
        id = json["id"].stringValue
        info = json["info"].stringValue
        look = json["look"].intValue
        looktime = json["looktime"].intValue
        name = json["name"].stringValue
        pf = json["pf"].stringValue
        pic = json["pic"].stringValue
        shareurl = json["shareurl"].stringValue
        state = json["state"].stringValue
        text = json["text"].stringValue
        type = json["type"].stringValue
        vip = json["vip"].stringValue
        year = json["year"].stringValue
        yuyan = json["yuyan"].stringValue
        zhuyan = json["zhuyan"].stringValue
        zu = [Zu]()
        let zuArray = json["zu"].arrayValue
        for zuJson in zuArray {
            let value = Zu(fromJson: zuJson)
            zu.append(value)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        if addtime != nil {
            dictionary["addtime"] = addtime
        }
        if cid != nil {
            dictionary["cid"] = cid
        }
        if cion != nil {
            dictionary["cion"] = cion
        }
        if cname != nil {
            dictionary["cname"] = cname
        }
        if commentCount != nil {
            dictionary["comment_count"] = commentCount
        }
        if daoyan != nil {
            dictionary["daoyan"] = daoyan
        }
        if dhits != nil {
            dictionary["dhits"] = dhits
        }
        if diqu != nil {
            dictionary["diqu"] = diqu
        }
        if fid != nil {
            dictionary["fid"] = fid
        }
        if hits != nil {
            dictionary["hits"] = hits
        }
        if id != nil {
            dictionary["id"] = id
        }
        if info != nil {
            dictionary["info"] = info
        }
        if look != nil {
            dictionary["look"] = look
        }
        if looktime != nil {
            dictionary["looktime"] = looktime
        }
        if name != nil {
            dictionary["name"] = name
        }
        if pf != nil {
            dictionary["pf"] = pf
        }
        if pic != nil {
            dictionary["pic"] = pic
        }
        if shareurl != nil {
            dictionary["shareurl"] = shareurl
        }
        if state != nil {
            dictionary["state"] = state
        }
        if text != nil {
            dictionary["text"] = text
        }
        if type != nil {
            dictionary["type"] = type
        }
        if vip != nil {
            dictionary["vip"] = vip
        }
        if year != nil {
            dictionary["year"] = year
        }
        if yuyan != nil {
            dictionary["yuyan"] = yuyan
        }
        if zhuyan != nil {
            dictionary["zhuyan"] = zhuyan
        }
        if zu != nil {
            var dictionaryElements = [[String: Any]]()
            for zuElement in zu {
                dictionaryElements.append(zuElement.toDictionary())
            }
            dictionary["zu"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        addtime = aDecoder.decodeObject(forKey: "addtime") as? String
        cid = aDecoder.decodeObject(forKey: "cid") as? String
        cion = aDecoder.decodeObject(forKey: "cion") as? String
        cname = aDecoder.decodeObject(forKey: "cname") as? String
        commentCount = aDecoder.decodeObject(forKey: "comment_count") as? Int
        daoyan = aDecoder.decodeObject(forKey: "daoyan") as? String
        dhits = aDecoder.decodeObject(forKey: "dhits") as? Int
        diqu = aDecoder.decodeObject(forKey: "diqu") as? String
        fid = aDecoder.decodeObject(forKey: "fid") as? String
        hits = aDecoder.decodeObject(forKey: "hits") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        info = aDecoder.decodeObject(forKey: "info") as? String
        look = aDecoder.decodeObject(forKey: "look") as? Int
        looktime = aDecoder.decodeObject(forKey: "looktime") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        pf = aDecoder.decodeObject(forKey: "pf") as? String
        pic = aDecoder.decodeObject(forKey: "pic") as? String
        shareurl = aDecoder.decodeObject(forKey: "shareurl") as? String
        state = aDecoder.decodeObject(forKey: "state") as? String
        text = aDecoder.decodeObject(forKey: "text") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
        vip = aDecoder.decodeObject(forKey: "vip") as? String
        year = aDecoder.decodeObject(forKey: "year") as? String
        yuyan = aDecoder.decodeObject(forKey: "yuyan") as? String
        zhuyan = aDecoder.decodeObject(forKey: "zhuyan") as? String
        zu = aDecoder.decodeObject(forKey: "zu") as? [Zu]
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder) {
        if addtime != nil {
            aCoder.encode(addtime, forKey: "addtime")
        }
        if cid != nil {
            aCoder.encode(cid, forKey: "cid")
        }
        if cion != nil {
            aCoder.encode(cion, forKey: "cion")
        }
        if cname != nil {
            aCoder.encode(cname, forKey: "cname")
        }
        if commentCount != nil {
            aCoder.encode(commentCount, forKey: "comment_count")
        }
        if daoyan != nil {
            aCoder.encode(daoyan, forKey: "daoyan")
        }
        if dhits != nil {
            aCoder.encode(dhits, forKey: "dhits")
        }
        if diqu != nil {
            aCoder.encode(diqu, forKey: "diqu")
        }
        if fid != nil {
            aCoder.encode(fid, forKey: "fid")
        }
        if hits != nil {
            aCoder.encode(hits, forKey: "hits")
        }
        if id != nil {
            aCoder.encode(id, forKey: "id")
        }
        if info != nil {
            aCoder.encode(info, forKey: "info")
        }
        if look != nil {
            aCoder.encode(look, forKey: "look")
        }
        if looktime != nil {
            aCoder.encode(looktime, forKey: "looktime")
        }
        if name != nil {
            aCoder.encode(name, forKey: "name")
        }
        if pf != nil {
            aCoder.encode(pf, forKey: "pf")
        }
        if pic != nil {
            aCoder.encode(pic, forKey: "pic")
        }
        if shareurl != nil {
            aCoder.encode(shareurl, forKey: "shareurl")
        }
        if state != nil {
            aCoder.encode(state, forKey: "state")
        }
        if text != nil {
            aCoder.encode(text, forKey: "text")
        }
        if type != nil {
            aCoder.encode(type, forKey: "type")
        }
        if vip != nil {
            aCoder.encode(vip, forKey: "vip")
        }
        if year != nil {
            aCoder.encode(year, forKey: "year")
        }
        if yuyan != nil {
            aCoder.encode(yuyan, forKey: "yuyan")
        }
        if zhuyan != nil {
            aCoder.encode(zhuyan, forKey: "zhuyan")
        }
        if zu != nil {
            aCoder.encode(zu, forKey: "zu")
        }
    }
}

class Zu: NSObject, NSCoding {
    var count: Int!
    var id: Int!
    var ji: [Ji]!
    var ly: String!
    var name: String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        count = json["count"].intValue
        id = json["id"].intValue
        ji = [Ji]()
        let jiArray = json["ji"].arrayValue
        for jiJson in jiArray {
            let value = Ji(fromJson: jiJson)
            ji.append(value)
        }
        ly = json["ly"].stringValue
        name = json["name"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        if count != nil {
            dictionary["count"] = count
        }
        if id != nil {
            dictionary["id"] = id
        }
        if ji != nil {
            var dictionaryElements = [[String: Any]]()
            for jiElement in ji {
                dictionaryElements.append(jiElement.toDictionary())
            }
            dictionary["ji"] = dictionaryElements
        }
        if ly != nil {
            dictionary["ly"] = ly
        }
        if name != nil {
            dictionary["name"] = name
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        count = aDecoder.decodeObject(forKey: "count") as? Int
        id = aDecoder.decodeObject(forKey: "id") as? Int
        ji = aDecoder.decodeObject(forKey: "ji") as? [Ji]
        ly = aDecoder.decodeObject(forKey: "ly") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder) {
        if count != nil {
            aCoder.encode(count, forKey: "count")
        }
        if id != nil {
            aCoder.encode(id, forKey: "id")
        }
        if ji != nil {
            aCoder.encode(ji, forKey: "ji")
        }
        if ly != nil {
            aCoder.encode(ly, forKey: "ly")
        }
        if name != nil {
            aCoder.encode(name, forKey: "name")
        }
    }
}

class Ji: NSObject, NSCoding {
    var ext: String!
    var id: Int!
    var name: String!
    var purl: String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        ext = json["ext"].stringValue
        id = json["id"].intValue
        name = json["name"].stringValue
        purl = json["purl"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        if ext != nil {
            dictionary["ext"] = ext
        }
        if id != nil {
            dictionary["id"] = id
        }
        if name != nil {
            dictionary["name"] = name
        }
        if purl != nil {
            dictionary["purl"] = purl
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        ext = aDecoder.decodeObject(forKey: "ext") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        purl = aDecoder.decodeObject(forKey: "purl") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder) {
        if ext != nil {
            aCoder.encode(ext, forKey: "ext")
        }
        if id != nil {
            aCoder.encode(id, forKey: "id")
        }
        if name != nil {
            aCoder.encode(name, forKey: "name")
        }
        if purl != nil {
            aCoder.encode(purl, forKey: "purl")
        }
    }
}
