//
//  SignUpViewController.swift
//  Joblr
//
//  Created by Zhaoming Qin on 10/26/19.
//  Copyright © 2019 Bear. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private var authUser : User? {
        return Auth.auth().currentUser
    }
    
    public func sendVerificationMail() {
        if self.authUser != nil && !self.authUser!.isEmailVerified {
            self.authUser!.sendEmailVerification(completion: { (error) in
                // Notify the user that the mail has sent or couldn't because of an error.
                self.showErrorPopUp("Please check you email and click the verification link", "Verification Link Sent")
            })
        }
        else {
            // Either the user is not available, or the user is already verified.
            self.showErrorPopUp("This user is not available, or the user is already verified. Please check again", "")
        }
    }
    
    /// This method will create a new user if all the entered information is valid; otherwise it will display an error message
    /// - Parameter sender: <#sender description#>
    @IBAction func signUpTapped(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil {
            // showError(error!)
            showErrorPopUp(error!, "Oops")
        } else {
            
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    // self.showError("Error creating user")
                    self.showErrorPopUp(error!.localizedDescription, "Oops")
                } else {
                    let db = Firestore.firestore()
                    db.collection("users").document(result!.user.uid).setData(["firstname": firstName, "lastname": lastName, "uid": result!.user.uid, "profileImageUrl": "", "gender": "Gender", "country": "Country", "phone": "xxx-xxx-xxxx"]) { (error) in
                        if error != nil {
                            // self.showError("Error saving user data")
                            self.showErrorPopUp(error!.localizedDescription, "Oops")
                        }
                    }
                db.collection("users").document(result!.user.uid).collection("Jobs").document("init").setData(["init": true])
                    self.sendVerificationMail()
                    // self.transitionToHome()
                }
            }
        }
     // collection.document.collection.document
    }
    
    /// This function checks the validation of all the fields of the sign up form.
    /// - returns: an error message corresponds to the type of the error that occured.
    func validateFields() -> String? {
        
        // check if any field is blank
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        let checkPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let checkConfirmedPassword = confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if checkPassword != checkConfirmedPassword {
            return "Please enter the same password"
        }
        
        
        if !isPasswordValid(checkPassword) {
            return "Please make sure your password is at lease 8 characters, contains a special character and a number"
        }
        
        return nil
    }
    
    /// This method checks whether the password is valid or not.
    /// - Parameter password: the password the user passed in when sign up.
    /// - Returns: true if it is valid; false otherwise
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    
    /// This method displays the error message
    /// - Parameter message: error message description
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func showErrorPopUp(_ message: String, _ title: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
    
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
