
//  CurrentUserProfile.swift
//
//
//  Created by Jingru Gao on 11/10/19.
//

import Foundation
import Firebase
import UIKit

protocol DocumentSerializable {
    init?(dictionary:[String: Any])
}

struct UserProfile {
    var uid: String?
    var email: String?
    var firstname: String?
    var lastname: String?
    var profileImageUrl: String?
    
    var dictionary:[String: Any] {
        return [
            "uid": uid,
            "email": email,
            "firstname": firstname,
            "lastname": lastname,
            "profileImageUrl": profileImageUrl
        ]
    }
}

extension UserProfile: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let uid = dictionary["uid"] as?String,
        let email = dictionary["email"] as? String,
        let firstname = dictionary["firstname"] as? String,
        let lastname = dictionary["lastname"] as? String,
        let profileImageUrl = dictionary["profileImageUrl"] as? String
        else {return nil}
        
        self.init(uid: uid, email: email, firstname: firstname, lastname: lastname, profileImageUrl: profileImageUrl)
    }
}

