//
//	IZMainModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class IZMainModel: NSObject, NSCoding {
    var code: Int!
    var data: [IZMainData]!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        code = json["code"].intValue
        data = [IZMainData]()
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray {
            let value = IZMainData(fromJson: dataJson)
            data.append(value)
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
            var dictionaryElements = [[String: Any]]()
            for dataElement in data {
                dictionaryElements.append(dataElement.toDictionary())
            }
            dictionary["data"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the IZMainData from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        code = aDecoder.decodeObject(forKey: "code") as? Int
        data = aDecoder.decodeObject(forKey: "data") as? [IZMainData]
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

class IZMainData: NSObject, NSCoding {
    var ad: Int!
    var id: String!
    var name: String!
    var pic: String!
    var url: String!
    var vod: [Vod]!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        ad = json["ad"].intValue
        id = json["id"].stringValue
        name = json["name"].stringValue
        pic = json["pic"].stringValue
        url = json["url"].stringValue
        vod = [Vod]()
        let vodArray = json["vod"].arrayValue
        for vodJson in vodArray {
            let value = Vod(fromJson: vodJson)
            vod.append(value)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        if ad != nil {
            dictionary["ad"] = ad
        }
        if id != nil {
            dictionary["id"] = id
        }
        if name != nil {
            dictionary["name"] = name
        }
        if pic != nil {
            dictionary["pic"] = pic
        }
        if url != nil {
            dictionary["url"] = url
        }
        if vod != nil {
            var dictionaryElements = [[String: Any]]()
            for vodElement in vod {
                dictionaryElements.append(vodElement.toDictionary())
            }
            dictionary["vod"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the IZMainData from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        ad = aDecoder.decodeObject(forKey: "ad") as? Int
        id = aDecoder.decodeObject(forKey: "id") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        pic = aDecoder.decodeObject(forKey: "pic") as? String
        url = aDecoder.decodeObject(forKey: "url") as? String
        vod = aDecoder.decodeObject(forKey: "vod") as? [Vod]
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder) {
        if ad != nil {
            aCoder.encode(ad, forKey: "ad")
        }
        if id != nil {
            aCoder.encode(id, forKey: "id")
        }
        if name != nil {
            aCoder.encode(name, forKey: "name")
        }
        if pic != nil {
            aCoder.encode(pic, forKey: "pic")
        }
        if url != nil {
            aCoder.encode(url, forKey: "url")
        }
        if vod != nil {
            aCoder.encode(vod, forKey: "vod")
        }
    }
}

class Vod: NSObject, NSCoding {
    var cion: String!
    var hits: String!
    var id: String!
    var info: String!
    var name: String!
    var pf: String!
    var pic: String!
    var state: String!
    var type: String!
    var vip: String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        cion = json["cion"].stringValue
        hits = json["hits"].stringValue
        id = json["id"].stringValue
        info = json["info"].stringValue
        name = json["name"].stringValue
        pf = json["pf"].stringValue
        pic = json["pic"].stringValue
        state = json["state"].stringValue
        type = json["type"].stringValue
        vip = json["vip"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        if cion != nil {
            dictionary["cion"] = cion
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
        if name != nil {
            dictionary["name"] = name
        }
        if pf != nil {
            dictionary["pf"] = pf
        }
        if pic != nil {
            dictionary["pic"] = pic
        }
        if state != nil {
            dictionary["state"] = state
        }
        if type != nil {
            dictionary["type"] = type
        }
        if vip != nil {
            dictionary["vip"] = vip
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the IZMainData from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        cion = aDecoder.decodeObject(forKey: "cion") as? String
        hits = aDecoder.decodeObject(forKey: "hits") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        info = aDecoder.decodeObject(forKey: "info") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        pf = aDecoder.decodeObject(forKey: "pf") as? String
        pic = aDecoder.decodeObject(forKey: "pic") as? String
        state = aDecoder.decodeObject(forKey: "state") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
        vip = aDecoder.decodeObject(forKey: "vip") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder) {
        if cion != nil {
            aCoder.encode(cion, forKey: "cion")
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
        if name != nil {
            aCoder.encode(name, forKey: "name")
        }
        if pf != nil {
            aCoder.encode(pf, forKey: "pf")
        }
        if pic != nil {
            aCoder.encode(pic, forKey: "pic")
        }
        if state != nil {
            aCoder.encode(state, forKey: "state")
        }
        if type != nil {
            aCoder.encode(type, forKey: "type")
        }
        if vip != nil {
            aCoder.encode(vip, forKey: "vip")
        }
    }
}
