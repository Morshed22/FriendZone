//
//  Friend.swift
//  FriendZone
//
//  Created by Morshed Alam on 3/3/18.
//  Copyright © 2018 GG. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Friend {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let phonenumber = "phonenumber"
        static let id = "id"
        static let lastname = "lastname"
        static let firstname = "firstname"
    }
    
    // MARK: Properties
    public var phonenumber: String?
    public var id: Int?
    public var lastname: String?
    public var firstname: String?
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public init(json: JSON) {
        phonenumber = json[SerializationKeys.phonenumber].string
        id = json[SerializationKeys.id].int
        lastname = json[SerializationKeys.lastname].string
        firstname = json[SerializationKeys.firstname].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = phonenumber { dictionary[SerializationKeys.phonenumber] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = lastname { dictionary[SerializationKeys.lastname] = value }
        if let value = firstname { dictionary[SerializationKeys.firstname] = value }
        return dictionary
    }
    
}
