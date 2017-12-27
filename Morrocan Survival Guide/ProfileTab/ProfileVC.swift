//
//  ProfileVC.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 9/11/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var notSignedInWarningLabel: UILabel!
    @IBOutlet var signInButton: UIBarButtonItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var questionsAskedButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    var ref: DatabaseReference!
    var storage: Storage!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setColors()
        ref = Database.database().reference()
        storage = Storage.storage()
        checkForCurrentUser()
        setupGestureRecognizer()
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.borderColor = UIColor.gray.cgColor
        
        imagePicker.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkForCurrentUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkForCurrentUser() {
        if Auth.auth().currentUser != nil {
            self.navigationItem.rightBarButtonItem = nil
            profileImage.isHidden = false
            nameLabel.isHidden = false
            questionsAskedButton.isHidden = false
            logOutButton.isHidden = false
            notSignedInWarningLabel.isHidden = true
            getProfileImage()
        } else {
            self.navigationItem.rightBarButtonItem = self.signInButton
            profileImage.isHidden = true
            nameLabel.isHidden = true
            questionsAskedButton.isHidden = true
            logOutButton.isHidden = true
            notSignedInWarningLabel.isHidden = false
        }
    }
    
    
    // MARK: - Firebase Calls Methods
    
    func getProfileImage() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            //print(value!)
            let name = value?["name"] as? String ?? ""
            //print(name)
            self.nameLabel.text = name
            if let imageURL = value?["profileImage"] as? String {
                // TODO: Fill out later when working with Firebase Storage
                let spaceRef = self.storage.reference(forURL: imageURL)
                spaceRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                    if let error = error {
                        print(error)
                    } else {
                        self.profileImage.image = UIImage(data: data!)
                    }
                })
            } else {
                print("Oh no, no picture")
                //let defaultProfileImageRef = Storage.storage(url: "gs://nuspace-a5b5b.appspot.com/DefaultUserImage.png")
                let spaceRef = self.storage.reference(forURL: "gs://moroccansurvivalguide.appspot.com/DefaultUserImage.png")
                spaceRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                    if let error = error {
                        print(error)
                        // Uh-oh, an error occurred!
                    } else {
                        // Data for "images/island.jpg" is returned
                        self.profileImage.image = UIImage(data: data!)
                    }
                })
                
                // TODO: Fill out later when working with Firebase Storage
            }
        })
    }
    
    func saveProfileImage(image: UIImage) {
        let userID = Auth.auth().currentUser?.uid
        let imageName = UUID().uuidString
        let storageRef = storage.reference().child("profileImages").child("\(imageName).png")
        let uploadData = UIImagePNGRepresentation(image)
        storageRef.putData(uploadData!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!)
                
            }
            if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                self.ref.child("users").child(userID!).child("profileImage").setValue(profileImageUrl)
            }
            self.getProfileImage()
        }
    }
    
    
    // MARK: - Button Touches
    
    @IBAction func questionsAskedListButton(_ sender: UIButton) {
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        try! Auth.auth().signOut()
        if Auth.auth().currentUser?.uid != nil {
        } else {
            self.navigationItem.rightBarButtonItem = self.signInButton
            profileImage.isHidden = true
            nameLabel.isHidden = true
            questionsAskedButton.isHidden = true
            logOutButton.isHidden = true
            notSignedInWarningLabel.isHidden = false
        }
    }
    
    
    // MARK: - Gesture Recognizer Methods
    
    func setupGestureRecognizer() {
        profileImage.isUserInteractionEnabled = true
        let profileImageTap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTap))
        profileImageTap.delegate = self as? UIGestureRecognizerDelegate
        profileImage.addGestureRecognizer(profileImageTap)
    }
    
    @objc func handleProfileImageTap(gestureRecognizer:UIGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.contentMode = .scaleAspectFit
            saveProfileImage(image: pickedImage)
            profileImage.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func setColors() {
        navigationController?.navigationBar.barTintColor = UIColor(red:229/255, green:167/255, blue:53/255, alpha:1.0)
        navigationController?.navigationBar.tintColor = UIColor(red: 73/255, green: 119/255, blue: 210/255, alpha: 1.0)
    }
    
}
