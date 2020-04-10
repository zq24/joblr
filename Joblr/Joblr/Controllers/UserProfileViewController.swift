//
//  UserProfileViewController.swift
//  Joblr
//
//  Created by Jingru Gao on 10/29/19.
//  Copyright © 2019 Bear. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


private let reuseIdentifier = "SettingsCell"


class UserProfileViewController: UIViewController {
    
    var tableView: UITableView!
    var userInfoHeader: UserInfoHeader!
    var firstnameShow: String!
    var lastnameShow: String!
    var emailShow: String!
    var phoneShow: String!
    var userProfileImage: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureUI()
        
        //        window = UIWindow()
        //        window?.makeKeyAndVisible()
        //        window?.rootViewController = UINavigationController(rootViewController:               ViewController())
        //
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureUI()
        self.currentUserProfile()
        self.tableView.reloadData()
    }
    
    
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
                db.collection("users").whereField("uid", isEqualTo: uid).getDocuments{(snapshot, error) in
                    let document = snapshot?.documents
                    for d in document!{
                        let data = d.data()
                        let firstname = data["firstname"]
                        let lastname = data["lastname"]
                        let profileImageUrl = data["profileImageUrl"]
                        self.firstnameShow = (firstname as! String)
                        self.lastnameShow = (lastname as! String)
                        self.emailShow = email
                        self.phoneShow = (data["phone"] as! String)
                        print(data)
                        let me = UserProfile(uid: uid, email: email, firstname: firstname as! String, lastname: lastname as!String, profileImageUrl: profileImageUrl as!String)
                        print("firstname \(me.firstname)")
                        print("lastname \(me.lastname)")
                        self.tableView.reloadData()
                        
                        
                    }
                }
            }
          // User is signed in.
          // ...
        } else {
          // No user is signed in.
          // ...
        }
        
    }
    
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self as? UITableViewDataSource
        tableView.rowHeight = 60
        
//        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(UserProfileCell.self, forCellReuseIdentifier: "userProfileCell")
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        userInfoHeader = UserInfoHeader(frame: frame)
        tableView.tableHeaderView = userInfoHeader
        tableView.tableFooterView = UIView()
    }
    
    func configureUI() {
        configureTableView()
        
        //navigationController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        //        navigationController?.navigationBar.barStyle = .black
        //        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        //        navigationItem.title = "Settings"
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22.0, weight: UIFont.Weight.bold)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(handleSignOutButtonType))
    }
    
    
    @objc func handleSignOutButtonType() {
        let alert = UIAlertController(title: "Sign out?", message: "You can always access your content by signing back in", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Sign out",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
                                        do {
                                            print("wait for signing out")
                                            try Auth.auth().signOut()
                                            UserDefaults.standard.set(false, forKey: "status")
                                            UserDefaults.standard.synchronize()
                                            let transitionPage = self.storyboard?.instantiateViewController(identifier: "transitionVC") as! HomeViewController
                                            transitionPage.modalPresentationStyle = .fullScreen
                                            //self.dismiss(animated: true, completion: nil)
                                            self.present(transitionPage, animated: true, completion: nil)
                                            print("try to go Home")

//                                            self.performSegue(withIdentifier: "goHome", sender: self)
                                            print("gone home")

                                            //                                                let launchStoryBoard = UIStoryboard(name: "LaunchScreen", bundle: nil)
//                                            let loginViewController = self.storyboard?.instantiateViewController(identifier: "WelcomeVC")as? ViewController
//                                            self.view.window?.rootViewController = loginViewController
//                                            self.view.window?.makeKeyAndVisible()

                                            // wait for team leader to edit

//                                            HomeViewController.unwindToStart(segue: UIStoryboardSegue)
//                                            self.performSegue(withIdentifier: "unwindToStart", sender: self)
                                            //                                            self.present(loginViewController!, animated: true, completion: nil)
                                        }

                                        catch let err {
                                            print("Failed to sign out with error", err)
                                        }
                                        //                                        self.present(UIViewController(), animated: true, completion: nil)

        }))
        //
        self.present(alert, animated: true, completion: nil)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = SettingsSection(rawValue: section) else {return 0}
        
        
        switch section {
        case .Settings: return SocialOptions.allCases.count
        case .BaseInfo: return CommunicationOptions.allCases.count
        }
        
        //return 5
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = SettingsSection(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        
        guard let section = SettingsSection(rawValue: indexPath.section) else {return UITableViewCell()}
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileCell") as! UserProfileCell
                
                
                switch section {
                case .Settings:
                    let social = SocialOptions(rawValue: indexPath.row)
                    cell.textLabel?.text = social?.description
        //            return cell
                case .BaseInfo:
                    let communication = CommunicationOptions(rawValue: indexPath.row)
                    cell.textLabel?.text = communication?.description
                    var phoneNumber: String?
                    if indexPath.row == 0 {
                        cell.content = self.phoneShow
        //                let user = Auth.auth().currentUser
        //                let db = Firestore.firestore()
        //                db.collection("users").whereField("uid", isEqualTo: user?.uid).getDocuments{(snapshot, error) in
        //                    let document = snapshot?.documents
        //                    for d in document! {
        //                        phoneNumber = d.data()["phone"] as! String
        //
        //                        print("----------------")
        //                        print(phoneNumber)
        //                        cell.content = phoneNumber
        //                        print("----------------")
        //                    }
        //                }
                    }
                    else {
                        cell.content = "Version 1.0"
                    }
//
//
//        switch section {
//        case .Social:
//            let social = SocialOptions(rawValue: indexPath.row)
//            cell.textLabel?.text = social?.description
//        case .Communications:
//            let communication = CommunicationOptions(rawValue: indexPath.row)
//            cell.textLabel?.text = communication?.description
//        }
//
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0  {
            if (indexPath.row == 0) {
                print("First row \(indexPath.row)")
                performSegue(withIdentifier: "testSegue", sender: self)
                //navigationController?.pushViewController(TestViewController(), animated: true)
            }
            else {
                
                print("\(indexPath.count)")
            }
            
            
        } else if indexPath.section == 1 {
            //self.pushViewController
        }
        
    }
}
