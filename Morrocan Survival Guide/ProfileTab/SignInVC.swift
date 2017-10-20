//
//  SignInVC.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 9/11/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var signInPage = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.isHidden = true
        nameTextField.isHidden = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkForCurrentUser() {
        if FIRAuth.auth()?.currentUser != nil {
            self.performSegue(withIdentifier: "toHome", sender: self)
        }
    }
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        if signInPage == true {
            if let email=emailTextField.text, let password=passwordTextField.text {
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                    if user != nil {
                        self.clearTextFields()
                        self.performSegue(withIdentifier: "toHome", sender: self)
                        print(user!.uid)
                    }
                    else {
                        
                        if let errCode = FIRAuthErrorCode(rawValue: (error! as NSError).code){
                            
                            // TODO: Need to fix errors through UI accordingly
                            switch errCode {
                            case .errorCodeInvalidEmail:
                                print("Invalid email")
                            case .errorCodeWrongPassword:
                                print("Password is wrong")
                            case .errorCodeUserDisabled:
                                print("User account is disabled")
                            case .errorCodeUserNotFound:
                                print("User account cannot be found")
                            default:
                                print("Wrong in some way!!!")
                            }
                        }
                        
                        print(error!)
                        
                    }
                })
            }
        } else {
            if let email=emailTextField.text, let password=passwordTextField.text, let name=nameTextField.text  {
                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                    if user != nil {
                        
                        
                        //DBProvider.Instance.saveUser(withID: user!.uid, email: email, password: password, name: name)
                        
                        
                        self.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: "toHome", sender: self)
                        
                    } else {
                        
                        if let errCode = FIRAuthErrorCode(rawValue: (error! as NSError).code){
                            
                            // TODO: Need to fix errors through UI accordingly
                            switch errCode {
                            case .errorCodeInvalidEmail:
                                print("Invalid email")
                            case .errorCodeEmailAlreadyInUse:
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
            signInButton.setTitle("Register", for: .normal)
            helpLabel.text = "Already have an account?"
            registerButton.setTitle("Sign-In Here", for: .normal)
        } else {
            signInPage = true
            nameLabel.isHidden = true
            nameTextField.isHidden = true
            signInButton.setTitle("Sign-In", for: .normal)
            helpLabel.text = "Don\'t have an account?"
            registerButton.setTitle("Register Here", for: .normal)
        }
    }


}
