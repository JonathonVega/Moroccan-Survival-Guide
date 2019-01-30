//
//  CreateThreadVC.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 12/12/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class CreateThreadVC: UIViewController {

    @IBOutlet weak var postTextView: UITextView!
    
    var creatorName: String = ""
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        postTextView.layer.cornerRadius = 10
        ref = Database.database().reference()
        getUserName()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Firebase Methods
    
    func addThreadToFirebase() {
        if postTextView.text.isEmpty {
            // TODO: Add in errors
        } else {
            let threadRef = self.ref.child("threads").childByAutoId()
            let threadRandomKey = threadRef.key
            let userID = Auth.auth().currentUser!.uid
            let date = Date().timeIntervalSince1970
            
                
            self.ref.child("users").child(userID).child("threads").child(threadRandomKey).setValue(date)
            
            
            let data: Dictionary<String, Any> = ["creator": creatorName, "creatorID":userID, "post": postTextView.text, "dateCreated":date] // Call date using "var date = NSDate(timeIntervalSince1970: interval)"
            self.ref.child("threads").child(threadRandomKey).setValue(data)
            
            
        }
    }
    
    func getUserName(){
        let userID = Auth.auth().currentUser!.uid
        ref.child("users").child(userID).child("name").observeSingleEvent(of: .value) { (snapshot) in
            if ( snapshot.value is NSNull ) {
                print("Response not found")
            } else {
                if let creator = snapshot.value as? String {
                    self.creatorName = creator
                }
            }
        }
    }
    
    @IBAction func createThread(_ sender: Any) {
        addThreadToFirebase()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelThreadCreation(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
