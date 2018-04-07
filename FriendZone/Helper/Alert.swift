//
//  Alert.swift
//  FriendZone
//
//  Created by Morshed Alam on 6/4/18.
//  Copyright © 2018 GG. All rights reserved.
//

import Foundation
import Action

struct AlertAction {
    let buttonTitle: String
    let handler: CocoaAction
}

struct SingleButtonAlert {
    let title: String
    let message: String?
    let action: AlertAction
}
