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

    @IBOutlet weak var subjectLabel: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageButton: UIButton!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Firebase Methods
    
    func addThreadToFirebase() {
        if (subjectLabel.text?.isEmpty)!, descriptionTextView.text.isEmpty {
            // TODO: Add in errors
        } else {
            let threadRef = self.ref.child("threads").childByAutoId()
            let threadRandomKey = threadRef.key
            let userID = Auth.auth().currentUser!.uid
            let date = Date().timeIntervalSince1970
            
            let data: Dictionary<String, Any> = ["creator":userID, "subject": subjectLabel.text!, "description": descriptionTextView.text, "dateCreated":date] // Call date using "var date = NSDate(timeIntervalSince1970: interval)"
            self.ref.child("threads").child(threadRandomKey).setValue(data)
            
            self.ref.child("users").child(userID).child("threads").child(threadRandomKey).setValue(date)
        }
    }
    

    @IBAction func addImage(_ sender: Any) {
    }
    
    @IBAction func createThread(_ sender: Any) {
        addThreadToFirebase()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelThreadCreation(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
