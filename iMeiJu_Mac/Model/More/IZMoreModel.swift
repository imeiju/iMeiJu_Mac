//
//	IZMoreModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class IZMoreModel: NSObject, NSCoding {
    var code: Int!
    var data: [IZMoreData]!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        code = json["code"].intValue
        data = [IZMoreData]()
        let moreDataArray = json["data"].arrayValue
        for moreDataJson in moreDataArray {
            let value = IZMoreData(fromJson: moreDataJson)
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
            for moreDataElement in data {
                dictionaryElements.append(moreDataElement.toDictionary())
            }
            dictionary["data"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        code = aDecoder.decodeObject(forKey: "code") as? Int
        data = aDecoder.decodeObject(forKey: "data") as? [IZMoreData]
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

//
//    IZMoreData.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class IZMoreData: NSObject, NSCoding {
    var ad: Int!
    var cid: String!
    var cion: String!
    var fid: String!
    var hits: String!
    var id: String!
    var info: String!
    var name: String!
    var pf: String!
    var pic: String!
    var pic2: String!
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
        ad = json["ad"].intValue
        cid = json["cid"].stringValue
        cion = json["cion"].stringValue
        fid = json["fid"].stringValue
        hits = json["hits"].stringValue
        id = json["id"].stringValue
        info = json["info"].stringValue
        name = json["name"].stringValue
        pf = json["pf"].stringValue
        pic = json["pic"].stringValue
        pic2 = json["pic2"].stringValue
        state = json["state"].stringValue
        type = json["type"].stringValue
        vip = json["vip"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        if ad != nil {
            dictionary["ad"] = ad
        }
        if cid != nil {
            dictionary["cid"] = cid
        }
        if cion != nil {
            dictionary["cion"] = cion
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
        if name != nil {
            dictionary["name"] = name
        }
        if pf != nil {
            dictionary["pf"] = pf
        }
        if pic != nil {
            dictionary["pic"] = pic
        }
        if pic2 != nil {
            dictionary["pic2"] = pic2
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
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        ad = aDecoder.decodeObject(forKey: "ad") as? Int
        cid = aDecoder.decodeObject(forKey: "cid") as? String
        cion = aDecoder.decodeObject(forKey: "cion") as? String
        fid = aDecoder.decodeObject(forKey: "fid") as? String
        hits = aDecoder.decodeObject(forKey: "hits") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        info = aDecoder.decodeObject(forKey: "info") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        pf = aDecoder.decodeObject(forKey: "pf") as? String
        pic = aDecoder.decodeObject(forKey: "pic") as? String
        pic2 = aDecoder.decodeObject(forKey: "pic2") as? String
        state = aDecoder.decodeObject(forKey: "state") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
        vip = aDecoder.decodeObject(forKey: "vip") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder) {
        if ad != nil {
            aCoder.encode(ad, forKey: "ad")
        }
        if cid != nil {
            aCoder.encode(cid, forKey: "cid")
        }
        if cion != nil {
            aCoder.encode(cion, forKey: "cion")
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
        if name != nil {
            aCoder.encode(name, forKey: "name")
        }
        if pf != nil {
            aCoder.encode(pf, forKey: "pf")
        }
        if pic != nil {
            aCoder.encode(pic, forKey: "pic")
        }
        if pic2 != nil {
            aCoder.encode(pic2, forKey: "pic2")
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
