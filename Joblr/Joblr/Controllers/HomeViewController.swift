//
//  HomeViewController.swift
//  Joblr
//
//  Created by Zhaoming Qin on 10/26/19.
//  Copyright © 2019 Bear. All rights reserved.
//

import UIKit

class HomeViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white

        if isLoggedIn() {
            // redirect to the user main page
            let userMainPageController = self.storyboard?.instantiateViewController(identifier: "MainTBC") as! MainTabBarController
            //userMainPageController.navigationController?.isNavigationBarHidden = true
            viewControllers = [userMainPageController]
        } else {
            // redirect to the welcome page
            perform(#selector(showWelcomeController), with: nil, afterDelay: 0.01)
        }
        
    }
    
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "status")
    }
    
    @objc func showWelcomeController() {
        let welcomeController = self.storyboard?.instantiateViewController(identifier: "NavVC") as! MainNavigationController
        welcomeController.modalPresentationStyle = .fullScreen
        present(welcomeController, animated: true, completion: nil)
    }
    

    
    @IBAction func unwindToStart(_ sender: UIStoryboardSegue) {
        print("back to home")
    }
}
