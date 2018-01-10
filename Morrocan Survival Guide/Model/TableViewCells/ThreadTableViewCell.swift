//
//  ThreadTableViewCell.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 11/3/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ThreadTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var responseCountLabel: UILabel!
    var threadID: String?
    
    var ref: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func trashThread(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Thread", message: "Are you sure you want to delete this thread?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: { (action) in
            self.removeThreadFromFirebase()
            print("Its deleted")
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Firebase Call Methods
    
    func removeThreadFromFirebase() {
        ref = Database.database().reference()
        ref.child("threads").child(threadID!).removeValue()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).child("threads").child(threadID!).removeValue()
    }
    
}
