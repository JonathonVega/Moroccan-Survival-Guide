//
//  CommentsVC.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 1/8/18.
//  Copyright © 2018 Jonathon Vega. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CommentsVC: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var threadID: String?
    var response: Reply?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var responseView: UIView!
    @IBOutlet weak var responseCreator: UILabel!
    @IBOutlet weak var responseCreateDate: UILabel!
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var replyToResponseButton: UIButton!
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var responseTrashButton: UIButton!
    
    var commentArray = [Reply]()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 200)
        scrollView.delegate = self
        commentTableView.delegate = self
        commentTableView.dataSource = self
        scrollView.bounces = false
        commentTableView.bounces = false
        commentTableView.isScrollEnabled = false
        scrollView.isScrollEnabled = true
        
        ref = Database.database().reference()
        
        fillResponseData()
        
        getCommentsOfResponseFromFirebase()
        
        if isCurrentUserEqualTo(replyUserKey: (response?.creatorKey)!) {
            responseTrashButton.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.containerViewHeight.constant = commentTableView.frame.minY + commentTableView.contentSize.height // Adjusts height so eventsTable can be scrolled down
        checkForCurrentUser()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! ReplyTableViewCell
        
        let comment = commentArray[indexPath.row]
        cell.userNameLabel.text = comment.creatorName
        cell.replyLabel.text = comment.reply
        cell.createDate.text = comment.createDate
        cell.threadID = self.threadID
        cell.responseID = self.response?.key
        cell.commentID = comment.key
        
        if isCurrentUserEqualTo(replyUserKey: comment.creatorKey!) {
            cell.commentTrashButton.isHidden = false
        }
        
        return cell
    }
    
    
    // MARK: - Firebase Call Methods
    
    func getCommentsOfResponseFromFirebase() {
        ref.child("threads").child(threadID!).child("responses").child((response?.key)!).child("comments").observe(.value) { (snapshot) in
            self.commentArray.removeAll()
            if ( snapshot.value is NSNull ) {
                print("Comment not found")
            } else {
                for child in (snapshot.children) {
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! [String: Any]
                    
                    
                    
                    let commentKey = snap.key
                    let commentString = dict["comment"] as! String
                    let userName = dict["userName"] as! String
                    let createDate = dict["createDate"] as! Double
                    let creatorKey = dict["userID"] as! String
                    
                    let createDateString = self.convertIntervalToDateString(interval: createDate)
                    
                    let comment = Reply(creatorKey: creatorKey, creatorName: userName, reply: commentString, createDate: createDateString, key: commentKey)
                    self.commentArray.append(comment)
                }
            }
            self.commentArray.reverse()
            self.commentTableView.reloadData()
        }
    }
    
    func removeResponseFromFirebase() {
        ref.child("threads").child(threadID!).child("responses").child((response?.key)!).removeValue()
    }
    
    
    // MARK: - Button Methods
    
    @IBAction func replyToResponse(_ sender: Any) {
        performSegue(withIdentifier: "createCommentSegue", sender: self)
    }
    
    @IBAction func removeResponse(_ sender: Any) {
        removeResponseFromFirebase()
    }
    
    
    // MARK: - Other Methods
    
    func checkForCurrentUser() {
        if Auth.auth().currentUser != nil {
            self.replyToResponseButton.isHidden = false
        } else {
            self.replyToResponseButton.isHidden = true
        }
    }
    
    func isCurrentUserEqualTo(replyUserKey: String) -> Bool {
        if Auth.auth().currentUser != nil {
            if Auth.auth().currentUser?.uid == replyUserKey {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func fillResponseData() {
        responseCreator.text = response?.creatorName
        responseCreateDate.text = response?.createDate
        responseLabel.text = response?.reply
    }
    
    func convertIntervalToDateString(interval:Double) -> String{
        let date = Date(timeIntervalSince1970: interval)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from:date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createCommentSegue" {
            let targetController = segue.destination as! CreateReplyVC
            targetController.threadID = self.threadID
            targetController.responseID = self.response?.key
            targetController.isResponse = false
        }
    }
    
    
    
}
