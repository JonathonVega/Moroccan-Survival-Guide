//
//  CreateReplyVC.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 12/15/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CreateReplyVC: UIViewController {

    var user:User?
    var threadID: String?
    var responseID: String?
    var isResponse:Bool? // true=response, false=comment
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        getUserInformation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addResponseToFirebase() {
        if (descriptionTextView.text.isEmpty) {
            // TODO: Add in errors
        } else {
            let responseRef = self.ref.child("responses").childByAutoId()
            let responseRandomKey = responseRef.key
            let userID = Auth.auth().currentUser!.uid
            let date = Date().timeIntervalSince1970
            
            
            
            let data: Dictionary<String, Any> = ["userID":userID, "userName":user!.name!, "response": descriptionTextView.text, "createDate":date] // Call date using "var date = NSDate(timeIntervalSince1970: interval)"
            self.ref.child("responses").child(responseRandomKey).setValue(data)
            
            self.ref.child("threads").child(threadID!).child("responses").child(responseRandomKey).setValue(data)
        }
    }
    
    /*func addCommentToFirebase() {
        if (descriptionTextView.text.isEmpty) {
            // TODO: Add in errors
        } else {
            let commentRef = self.ref.child("responses").child(responseID).childByAutoId()
            let commentRandomKey = commentRef.key
            let userID = Auth.auth().currentUser!.uid
            let date = Date().timeIntervalSince1970
            
            let data: Dictionary<String, Any> = ["user":userID, "comment": descriptionTextView.text, "createDate":date] // Call date using "var date = NSDate(timeIntervalSince1970: interval)"
            self.ref.child("responses").child(responseID).child("comments").child(commentRandomKey).setValue(data)
        }
    }*/
    
    func getUserInformation() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value) { (snapshot) in
            if(snapshot.value is NSNull) {
                print("not found")
            } else {
                let dict = snapshot.value as! [String: Any]
                let name = dict["name"] as! String
                
                self.user = User(name: name)
            }
        }
    }
    
    
    @IBAction func createReply(_ sender: Any) {
        if(isResponse)!{
            addResponseToFirebase()
            dismiss(animated: true, completion: nil)
        }else {
            //addCommentToFirebase()
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelReply(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
