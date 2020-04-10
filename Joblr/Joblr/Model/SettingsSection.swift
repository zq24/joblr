//
//  File.swift
//  Joblr
//
//  Created by Jingru Gao on 10/30/19.
//  Copyright © 2019 Bear. All rights reserved.
//

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    case Settings
    case BaseInfo
    
    var description: String {
        switch self {
        case .Settings: return ""
        case .BaseInfo: return ""
        }
    }
}


enum SocialOptions: Int, CaseIterable, CustomStringConvertible {
    case editProfile
//    case switchAccount
    
    var description: String {
        switch self {
        case .editProfile: return "Edit Profile"
//        case .switchAccount:
//            return "Switch Account"
        }
    }
}

enum CommunicationOptions: Int, CaseIterable, CustomStringConvertible {
//    case notifications
//    case email
    case phone
    case About
//    case reportCrashes
    
    var description: String {
        switch self {
//        case .notifications: return "Notification"
//        case .email: return "Email"
        case .phone: return "Phone"
        case .About: return "About"
//        case .reportCrashes: return "Report Crashes"
        }
    }
}
