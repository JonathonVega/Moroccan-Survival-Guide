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

class ProfileVC: UIViewController {

    @IBOutlet weak var NotSignedInWarningLabel: UILabel!
    @IBOutlet weak var signInButton: UIBarButtonItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var questionsAskedButton: UIButton!
    
    var ref: DatabaseReference!
    var storage: Storage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        storage = Storage.storage()
        checkForCurrentUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkForCurrentUser() {
        if Auth.auth().currentUser != nil {
            self.navigationItem.rightBarButtonItem = nil
            getProfileImage()
        }
    }
    
    func getProfileImage() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            //print(value!)
            let name = value?["name"] as? String ?? ""
            //print(name)
            self.nameLabel.text = name
            if let image = value?["profileImage"] as? String {
                // TODO: Fill out later when working with Firebase Storage
                print("Nothing Should be coming out")
                print(image)
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
    
    @IBAction func questionsAskedListButton(_ sender: UIButton) {
    }
    
    @IBAction func changeProfilePassword(_ sender: UIButton) {
    }

}
