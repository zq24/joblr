//
//  ProfileEditingViewController.swift
//  Joblr
//
//  Created by Jingru Gao on 11/1/19.
//  Copyright © 2019 Bear. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage
import FirebaseFirestore


class ProfileEditingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var saveProfileButton: UIButton!
    @IBOutlet weak var cancelSaveProfileButton: UIButton!
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    
    var image: UIImage? = nil
    var firstNameInput: String = ""
    var lastNameInput: String = ""
    var genderInput: String = ""
    var phoneInput: String = ""
    var countryInput: String = ""
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        genderTextField.delegate = self
        phoneTextField.delegate = self
        countryTextField.delegate = self
        setupUserProfileData()
        setupUserProfileImage()
        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        genderTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        countryTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setupUserProfileImage() {
        userProfileImage.layer.cornerRadius = 40
        userProfileImage.clipsToBounds = true
        userProfileImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        userProfileImage.addGestureRecognizer(tapGesture)
    }
    
    func setupUserProfileData() {
        let user = Auth.auth().currentUser
        self.db.collection("users").document(user!.uid).getDocument{(document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.firstNameInput = data!["firstname"] as! String
                self.lastNameInput = data!["lastname"] as! String
                self.genderInput = data!["gender"] as! String
                self.phoneInput = data!["phone"] as! String
                self.countryInput = data!["country"] as! String
                
                self.firstNameTextField.placeholder = self.firstNameInput
                self.lastNameTextField.placeholder = self.lastNameInput
                self.genderTextField.placeholder = self.genderInput
                self.phoneTextField.placeholder = self.phoneInput
                self.countryTextField.placeholder = self.countryInput
                
                
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func uploadProfileImage() {
        guard let imageSelected = self.image else {
            print("Profile image is nil")
            return
        }
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            return
        }
        let user = Auth.auth().currentUser
        let storageRef = Storage.storage().reference(forURL: "gs://joblr-fc6e5.appspot.com")
        let storageProfileRef = storageRef.child("profile").child(user!.uid)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metadata, completion: {(StorageMetadata, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            storageProfileRef.downloadURL(completion: {(url, error) in
                if let metaImageUrl = url?.absoluteString {
                    self.db.collection("users").document(user!.uid).setData(["profileImageUrl": metaImageUrl], merge: true) {
                        (error:Error?) in
                        if let error = error {
                            print("Data could not be saved: \(error).")
                        } else {
                            print("Data saved successfully!")
                        }
                    }
                }
            })
        })
    }
    
    
    func editProfile() {
        let user = Auth.auth().currentUser
        self.db.collection("users").document(user!.uid).getDocument{(document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if self.firstNameTextField.text != "" {
                    self.firstNameInput = self.firstNameTextField.text!.trimmingCharacters(in: .whitespaces)
                }
                if self.lastNameTextField.text != "" {
                    self.lastNameInput = self.lastNameTextField.text!.trimmingCharacters(in: .whitespaces)
                }
                if self.genderTextField.text != "" {
                    self.genderInput = self.genderTextField.text!.trimmingCharacters(in: .whitespaces)
                }
                
                if self.phoneTextField.text != "" {
                    self.phoneInput = self.phoneTextField.text!.trimmingCharacters(in: .whitespaces)
                }
                
                if self.countryTextField.text != "" {
                    self.countryInput = self.countryTextField.text!.trimmingCharacters(in: .whitespaces)
                }
                
                self.db.collection("users").document(user!.uid).setData(["firstname": self.firstNameInput, "lastname": self.lastNameInput, "gender": self.genderInput, "phone": self.phoneInput, "country": self.countryInput], merge: true) {
                    (error:Error?) in
                    if let error = error {
                        print("Data could not be saved: \(error).")
                    } else {
                        print("Data saved successfully!")
                    }
                }
            }
        }
    }
    
    @IBAction func saveProfile(_ sender: Any) {
        uploadProfileImage()
        editProfile()
        
        let alert = UIAlertController(title: "Saved", message: "Click button below and go to main page", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Main",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        do {
                                            let mainTabBarController = self.storyboard?.instantiateViewController(identifier: "MainTBC")as? MainTabBarController
                                            self.view.window?.rootViewController = mainTabBarController
                                            self.view.window?.makeKeyAndVisible()
                                            
                                        }
                                            
                                        catch let err {
                                            print("Failed to edit profile with error", err)
                                        }
                                        
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func notSaveProfile(_ sender: Any) {
        let alert = UIAlertController(title: "Canceled Editing", message: "Click button below and go to main page", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Main",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        do {
                                            let mainTabBarController = self.storyboard?.instantiateViewController(identifier: "MainTBC")as? MainTabBarController
                                            self.view.window?.rootViewController = mainTabBarController
                                            self.view.window?.makeKeyAndVisible()
                                            
                                        }
                                            
                                        catch let err {
                                            print("Failed to edit profile with error", err)
                                        }
                                        
        }))
        self.present(alert, animated: true, completion: nil)
        return
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


extension ProfileEditingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            image = imageSelected
            userProfileImage.image = imageSelected
            
        }
        
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as?
            UIImage{
            image = imageOriginal
            userProfileImage.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
