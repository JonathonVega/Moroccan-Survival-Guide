//
//  SignInVC.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 9/11/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignInVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var warningLabel: UILabel!
    
    var signInPage = true
    
    var ref: DatabaseReference!
    var storage: Storage!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        storage = Storage.storage()
        
        warningLabel.isHidden = true
        nameLabel.isHidden = true
        nameTextField.isHidden = true
        emailTextField.keyboardType = .emailAddress
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Firebase Calls
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        // Signing In
        if signInPage == true {
            if let email=emailTextField.text, !email.isEmpty, let password=passwordTextField.text, !password.isEmpty {
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if user != nil {
                        self.clearTextFields()
                        self.navigationController?.popViewController(animated: true)
                    }
                    else {
                        
                        if let errCode = AuthErrorCode(rawValue: (error! as NSError).code){
                            
                            // TODO: Need to fix errors through UI accordingly
                            switch errCode {
                            case .invalidEmail:
                                self.warningLabel.text = "* Email is invalid!"
                                self.warningLabel.isHidden = false
                                print("Invalid email")
                            case .wrongPassword:
                                self.warningLabel.text = "* Password is wrong!"
                                self.warningLabel.isHidden = false
                                print("Password is wrong")
                            case .userDisabled:
                                self.warningLabel.text = "* User account is disabled!"
                                self.warningLabel.isHidden = false
                                print("User account is disabled")
                            case .userNotFound:
                                self.warningLabel.text = "* User account cannot be found!"
                                self.warningLabel.isHidden = false
                                print("User account cannot be found")
                            default:
                                self.warningLabel.text = "* All fields must be filled!"
                                self.warningLabel.isHidden = false
                                print("Wrong in some way!!!")
                            }
                        }
                        
                        print(error!)
                        
                    }
                })
            } else {
                self.warningLabel.text = "* All fields must be filled!"
                self.warningLabel.isHidden = false
            }
        // Registering a new account
        } else {
            if let email=emailTextField.text, !email.isEmpty, let password=passwordTextField.text, !password.isEmpty, let name=nameTextField.text, !name.isEmpty {
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    if user != nil {
                        
                        let data: Dictionary<String, Any> = ["email": email, "password": password, "name": name, "dateCreated":Date().timeIntervalSince1970] // Call date using "var date = NSDate(timeIntervalSince1970: interval)"
                        self.ref.child("users").child(user!.uid).setValue(data)
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    } else {
                        if let errCode = AuthErrorCode(rawValue: (error! as NSError).code){
                            
                            // TODO: Need to fix errors through UI accordingly
                            switch errCode {
                            case .invalidEmail:
                                self.warningLabel.text = "* Email is invalid!"
                                self.warningLabel.isHidden = false
                                print("Email is invalid")
                            case .emailAlreadyInUse:
                                self.warningLabel.text = "* Email is already in use!"
                                self.warningLabel.isHidden = false
                                print("Email is already in use")
                            default:
                                self.warningLabel.text = "* All fields must be filled!"
                                self.warningLabel.isHidden = false
                                print("All fields must be filled")
                            }
                        }
                    }
                })
            } else {
                self.warningLabel.text = "* All fields must be filled!"
                self.warningLabel.isHidden = false
            }
        }
    }
    
    func clearTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func changeSignInPage(_ sender: UIButton) {
        if signInPage {
            signInPage = false
            nameLabel.isHidden = false
            nameTextField.isHidden = false
            warningLabel.isHidden = true
            signInButton.setTitle("Register", for: .normal)
            helpLabel.text = "Already have an account?"
            registerButton.setTitle("Sign-In Here", for: .normal)
        } else {
            signInPage = true
            nameLabel.isHidden = true
            nameTextField.isHidden = true
            warningLabel.isHidden = true
            signInButton.setTitle("Sign-In", for: .normal)
            helpLabel.text = "Don\'t have an account?"
            registerButton.setTitle("Register Here", for: .normal)
        }
    }
    
}
