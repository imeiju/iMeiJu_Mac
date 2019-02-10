//
//  LCBool.swift
//  LeanCloud
//
//  Created by Tang Tianyong on 2/27/16.
//  Copyright © 2016 LeanCloud. All rights reserved.
//

import Foundation

/**
 LeanCloud boolean type.

 It is a wrapper of `Swift.Bool` type, used to store a boolean value.
 */
public final class LCBool: NSObject, LCValue, LCValueExtension, ExpressibleByBooleanLiteral {
    public private(set) var value: Bool = false

    public override init() {
        super.init()
    }

    public convenience init(_ value: Bool) {
        self.init()
        self.value = value
    }

    public required convenience init(booleanLiteral value: BooleanLiteralType) {
        self.init(value)
    }

    public required init?(coder aDecoder: NSCoder) {
        value = aDecoder.decodeBool(forKey: "value")
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(value, forKey: "value")
    }

    public func copy(with _: NSZone?) -> Any {
        return LCBool(value)
    }

    public override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? LCBool {
            return object === self || object.value == value
        } else {
            return false
        }
    }

    public var jsonValue: Any {
        return value
    }

    func formattedJSONString(indentLevel _: Int, numberOfSpacesForOneIndentLevel _: Int = 4) -> String {
        return "\(value)"
    }

    public var jsonString: String {
        return formattedJSONString(indentLevel: 0)
    }

    public var rawValue: LCValueConvertible {
        return value
    }

    var lconValue: Any? {
        return jsonValue
    }

    static func instance() -> LCValue {
        return LCBool()
    }

    func forEachChild(_: (_ child: LCValue) throws -> Void) rethrows {
        /* Nothing to do. */
    }

    func add(_: LCValue) throws -> LCValue {
        throw LCError(code: .invalidType, reason: "Object cannot be added.")
    }

    func concatenate(_: LCValue, unique _: Bool) throws -> LCValue {
        throw LCError(code: .invalidType, reason: "Object cannot be concatenated.")
    }

    func differ(_: LCValue) throws -> LCValue {
        throw LCError(code: .invalidType, reason: "Object cannot be differed.")
    }
}
