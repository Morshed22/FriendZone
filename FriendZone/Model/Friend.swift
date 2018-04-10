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
    
    private struct SerializationKeys {
        static let phonenumber = "phonenumber"
        static let id = "id"
        static let lastname = "lastname"
        static let firstname = "firstname"
    }
    
    // MARK: Properties
     var phonenumber: String
     var id: Int
     var lastname: String
     var firstname: String

}
extension Friend {
        
        init?(json: JSON) {
        guard  let phonenumber = json[SerializationKeys.phonenumber].string,
               let id = json[SerializationKeys.id].int,
               let lastname = json[SerializationKeys.lastname].string,
               let firstname = json[SerializationKeys.firstname].string  else {
                    return nil
            }
            
            self.id = id
            self.firstname = firstname
            self.lastname = lastname
            self.phonenumber = phonenumber
        }
    }
