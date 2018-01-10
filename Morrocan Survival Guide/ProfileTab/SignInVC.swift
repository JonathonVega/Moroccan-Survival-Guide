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
    
    var signInPage = true
    
    var ref: DatabaseReference!
    var storage: Storage!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        storage = Storage.storage()
        
        nameLabel.isHidden = true
        nameTextField.isHidden = true
        profileImageButton.isHidden = true
        profileImageButton.layer.borderWidth = 1.0
        profileImageButton.layer.borderColor = UIColor.black.cgColor
        
        imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Firebase Calls
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        // Signing In
        if signInPage == true {
            if let email=emailTextField.text, let password=passwordTextField.text {
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if user != nil {
                        self.clearTextFields()
                        self.navigationController?.popViewController(animated: true)
                        print(user!.uid)
                    }
                    else {
                        
                        if let errCode = AuthErrorCode(rawValue: (error! as NSError).code){
                            
                            // TODO: Need to fix errors through UI accordingly
                            switch errCode {
                            case .invalidEmail:
                                print("Invalid email")
                            case .wrongPassword:
                                print("Password is wrong")
                            case .userDisabled:
                                print("User account is disabled")
                            case .userNotFound:
                                print("User account cannot be found")
                            default:
                                print("Wrong in some way!!!")
                            }
                        }
                        
                        print(error!)
                        
                    }
                })
            }
        // Registering a new account
        } else {
            if let email=emailTextField.text, let password=passwordTextField.text, let name=nameTextField.text  {
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    if user != nil {
                        
                        let data: Dictionary<String, Any> = ["email": email, "password": password, "name": name, "dateCreated":Date().timeIntervalSince1970] // Call date using "var date = NSDate(timeIntervalSince1970: interval)"
                        self.ref.child("users").child(user!.uid).setValue(data)
                        
                        if(self.profileImageButton.imageView?.image != nil) {
                            let imageName = UUID().uuidString
                            let storageRef = self.storage.reference().child("profileImages").child("\(imageName).png")
                            let uploadData = UIImagePNGRepresentation((self.profileImageButton.imageView?.image)!)
                            storageRef.putData(uploadData!, metadata: nil) { (metadata, error) in
                                if error != nil {
                                    print(error!)
                                } else {
                                    // Initial setup for email verification
                                    
                                    /*Auth.auth().currentUser!.sendEmailVerification(completion: { (error) in
                                    })
                                    let alert = UIAlertController(title: "Account Created", message: "Please verify your email by confirming the sent link.", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)*/
                                }
                                
                                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                                    self.ref.child("users").child(user!.uid).child("profileImage").setValue(profileImageUrl)
                                }
                            }
                        }
                        print("Is registering")
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    } else {
                        if let errCode = AuthErrorCode(rawValue: (error! as NSError).code){
                            
                            // TODO: Need to fix errors through UI accordingly
                            switch errCode {
                            case .invalidEmail:
                                print("Invalid email")
                            case .emailAlreadyInUse:
                                print("Email already in use")
                            default:
                                print("Wrong in some way!!!")
                            }
                        }
                        print(error!)
                    }
                    
                    
                })
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
            profileImageButton.isHidden = false
            signInButton.setTitle("Register", for: .normal)
            helpLabel.text = "Already have an account?"
            registerButton.setTitle("Sign-In Here", for: .normal)
        } else {
            signInPage = true
            nameLabel.isHidden = true
            nameTextField.isHidden = true
            profileImageButton.isHidden = true
            signInButton.setTitle("Sign-In", for: .normal)
            helpLabel.text = "Don\'t have an account?"
            registerButton.setTitle("Register Here", for: .normal)
        }
    }

    @IBAction func touchOnProfileImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Image Picker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageButton.imageView?.contentMode = .scaleAspectFill
            profileImageButton.imageView?.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
}
