//
//  LoginViewController.swift
//  Joblr
//
//  Created by Zhaoming Qin on 10/26/19.
//  Copyright © 2019 Bear. All rights reserved.
//

import UIKit
import FirebaseAuth
import AVKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var videoPlayer: AVPlayer?
    
    var videoPlayerLayer: AVPlayerLayer?
    
    
    @IBOutlet weak var emailTextField: ShakingTextField!
    @IBOutlet weak var passwordTextField: ShakingTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        errorLabel.alpha = 0
        // Do any additional setup after loading the view.
        let emailIcon = UIImage(named: "icons8-email-64")
        addIconToTextField(textField: emailTextField, image: emailIcon!)
        let passwordIcon = UIImage(named: "icons8-password-64")
        addIconToTextField(textField: passwordTextField, image: passwordIcon!)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }

    @objc func dismissKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpVideo()
    }
    
    /// This method adds an icon to the left side of the textfield of the login view
    /// - Parameter textField: a textfield
    /// - Parameter image: an icon that is going to be added
    func addIconToTextField(textField: UITextField, image: UIImage) {
        let leftIconView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 20, height: 20))
        leftIconView.image = image
        textField.leftView = leftIconView
        textField.leftViewMode = .always
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        // validate the given fields, make sure they are not nil.
        if (emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            passwordTextField.shake()
            emailTextField.shake()
            errorLabel.text = "Please fill out all the fields"
            errorLabel.alpha = 1
            return
        }
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                self.passwordTextField.shake()
                self.emailTextField.shake()
                self.errorLabel.text = error?.localizedDescription
                self.errorLabel.alpha = 1
                return
            }
            
            let user = authResult?.user
            
            if user!.isEmailVerified {
                UserDefaults.standard.set(true, forKey: "status")
                UserDefaults.standard.synchronize()
                self.transitionToHome()
            } else {
                self.errorLabel.text = "User is available but has not verify his/her email yet"
                self.errorLabel.alpha = 1
            }
            
        }
    }
    
    func transitionToHome() {
        
        let mainTabBarController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.mainTabBarController) as? MainTabBarController
        mainTabBarController?.modalPresentationStyle = .fullScreen
        self.present(mainTabBarController!, animated: false, completion: nil)
//        self.view.window?.rootViewController = mainTabBarController
//        self.view.window?.makeKeyAndVisible()
//        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeViewController
//        view.window?.rootViewController = homeViewController
//        view.window?.makeKeyAndVisible()
    }
    
    func setUpVideo() {
        
        let bundlePath = Bundle.main.path(forResource: "Joblr", ofType: "mp4")
        
        guard bundlePath != nil else {
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
        let item = AVPlayerItem(url: url)
        
        videoPlayer = AVPlayer(playerItem: item)
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width / 1.35, y: -self.view.frame.size.height / 4, width: self.view.frame.size.width * 2.5, height: self.view.frame.size.height)
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        videoPlayer?.playImmediately(atRate: 1.0)
    }
}
