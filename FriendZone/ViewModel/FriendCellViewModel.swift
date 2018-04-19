//
//  FriendCellViewModel.swift
//  FriendZone
//
//  Created by Morshed Alam on 9/4/18.
//  Copyright © 2018 GG. All rights reserved.
//

import Foundation

protocol FriendCellViewModel {
    var friendItem: Friend { get }
    var fullName: String { get }
    var phonenumberText: String { get }
}

extension Friend: FriendCellViewModel {
    var friendItem: Friend {
        return self
    }
    var fullName: String {
        return firstname + " " + lastname
    }
    var phonenumberText: String {
        return phonenumber
    }
}
