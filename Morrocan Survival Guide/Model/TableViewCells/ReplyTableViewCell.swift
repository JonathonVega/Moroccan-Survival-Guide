//
//  ReplyTableViewCell.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 12/15/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ReplyTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createDate: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var numberOfCommentsLabel: UILabel!
    var threadID: String?
    var responseID: String?
    var commentID: String?
    
    @IBOutlet weak var commentTrashButton: UIButton!
    
    var ref: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func removeComment(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Comment", message: "Are you sure you want to delete this comment?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: { (action) in
            self.removeCommentFromFirebase()
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Firebase Call Methods
    
    func removeCommentFromFirebase() {
        ref = Database.database().reference()
        ref.child("threads").child(threadID!).child("responses").child(responseID!).child("comments").child(commentID!).removeValue()
    }
    
}
