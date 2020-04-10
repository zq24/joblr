//
//  UserInfoHeader.swift
//  Joblr
//
//  Created by Jingru Gao on 10/30/19.
//  Copyright © 2019 Bear. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UserInfoHeader: UIView {

    // MARK: - Properties
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.image = UIImage(named: "ironman")
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        var code = 0x1F434
        var scalar = UnicodeScalar(code)
//        label.text = "Tony Scalar"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
//        label.text = "tony.horse@gmail.com"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        currentUserProfile()
        let profileImageDimension: CGFloat = 60
        
        addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profileImageView.layer.cornerRadius = profileImageDimension / 2
        
        addSubview(usernameLabel)
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -10).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        
        addSubview(emailLabel)
        emailLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 10).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

     func currentUserProfile() {
            //let me = UserProfile.self
            if Auth.auth().currentUser != nil {
                let db = Firestore.firestore()
                let user = Auth.auth().currentUser
                if let user = user {
                    // The user's ID, unique to the Firebase project.
                    // Do NOT use this value to authenticate with your backend server,
                    // if you have one. Use getTokenWithCompletion:completion: instead.
                    let uid = user.uid
                    let email = user.email
                  //let photoURL = user.photoURL
                    db.collection("users").whereField("uid", isEqualTo: uid).getDocuments{(snapshot, error) in
                        let document = snapshot?.documents
                        for d in document!{
                            let data = d.data()
                            let firstname = data["firstname"]
                            let lastname = data["lastname"]
                            let profileImageUrl = data["profileImageUrl"]
                            //TODO: Add phone number here
                            print(data)
                            
                            
                            
                            let me = UserProfile(uid: uid, email: email, firstname: firstname as! String, lastname: lastname as!String, profileImageUrl: profileImageUrl as!String)
                            
                            self.usernameLabel.text = me.firstname! + " " + me.lastname!
                            self.emailLabel.text = me.email
                            if me.profileImageUrl != "" {
                                self.loadProfileImage(myPath: me.profileImageUrl!)
                            }
                            
//                            let url = URL(string: me.profileImageUrl!)
//                            let imgdata = try? Data(contentsOf: url!)
//
//                            if let imageData = imgdata {
//                                self.profileImageView.image = UIImage(data: imageData)
//                            }
                        }
                    }
                    print("uid \(uid)")
                    print("email \(email)")
                    
                    
                  // ...
                }
              // User is signed in.
              // ...
            } else {
              // No user is signed in.
              // ...
            }
            
        }
    
    func loadProfileImage(myPath: String) {
        let url = URL(string: myPath)
        let imgdata = try? Data(contentsOf: url!)

        if let imageData = imgdata {
            self.profileImageView.image = UIImage(data: imageData)
        }
    }
    
}
