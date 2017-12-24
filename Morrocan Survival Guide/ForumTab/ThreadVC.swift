//
//  ThreadVC.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 12/12/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ThreadVC: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var threadID: String?
    var responseID: String?

    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var threadHeadingView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var commentTableContainerView: UIView!
    @IBOutlet weak var commentTableView: UITableView!
    //var commentTableView: UITableView?
    
    
    // MARK: - commentTableView ResponseView (CTRV)
    
    @IBOutlet weak var CTRVUserImage: UIImageView!
    @IBOutlet weak var CTRVResponseLabel: UILabel!
    @IBOutlet weak var CTRVUserNameLabel: UILabel!
    @IBOutlet weak var CTRVCreateDateLabel: UILabel!
    
//    // MARK: - commentTableView (CT)
//
//    @IBOutlet weak var CTUserImage: UIImageView!
//    @IBOutlet weak var CTCommentLabel: UILabel!
//    @IBOutlet weak var CTUserNameLabel: UILabel!
//    @IBOutlet weak var CTCreateDateLabel: UILabel!
    
    
    
    var responseArray = [Reply]()
    var commentArray = [Reply]()
    
    let screenHeight = UIScreen.main.bounds.height//UIScreen.main.Screen().bounds.height
    let scrollViewContentHeight = 900 as CGFloat
    var touchedResponsePosition: CGPoint?
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 200)
        scrollView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        scrollView.bounces = false
        tableView.bounces = false
        tableView.isScrollEnabled = false
        commentTableContainerView.isHidden = true
        commentTableView.isScrollEnabled = false
        commentTableView.isHidden = true
        commentTableView.isUserInteractionEnabled = true
        
        ref = Database.database().reference()
        
        getThreadDataFromFirebase()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.containerViewHeight.constant = tableView.frame.minY + tableView.contentSize.height // Adjusts height so eventsTable can be scrolled down
        self.commentTableContainerView.frame.origin.y = self.tableView.frame.maxY
        ///commentTableView.isHidden = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if scrollView == self.scrollView {
            if yOffset > 0 {//yOffset >= scrollViewContentHeight - screenHeight {
                //print("It hits this")
            }
        }
    }
    
    
    // MARK: - TableView Delegate and Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        if(tableView == self.tableView) {
            count = responseArray.count
        } else if(tableView == self.commentTableView) {
            count = commentArray.count
            //count = 0
        }
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == self.tableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "response", for: indexPath) as! ReplyTableViewCell
            
            let response = responseArray[indexPath.row]
            cell.userNameLabel.text = response.creatorName
            cell.replyLabel.text = response.reply
            cell.createDate.text = response.createDate
            
            commentTableContainerView.frame.origin = CGPoint(x: 0, y: containerView.frame.maxY)
            //commentTableContainerView.frame.size.height = /*tableView.frame.minY +*/ commentTableView.contentSize.height
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! ReplyTableViewCell
            cell.selectionStyle = .none
            
            let comment = commentArray[indexPath.row]
            cell.userNameLabel.text = comment.creatorName
            cell.replyLabel.text = comment.reply
            cell.createDate.text = comment.createDate
            
            
            //commentTableView.setContentOffset(CGPoint.zero, animated: true)
            ///self.commentTableView.frame.size.height = commentTableView.contentSize.height
            ///self.commentTableContainerView.frame.size.height = commentTableView.contentSize.height
            
            //self.containerView.frame.size.height = commentTableView.contentSize.height + self.tableView.frame.minY
            ///self.tableView.frame.size.height = commentTableView.contentSize.height
            //self.containerView.frame.size.height = commentTableView.contentSize.height + self.tableView.frame.minY
            ///self.scrollView.contentSize.height = self.tableView.frame.minY + commentTableView.contentSize.height
            
//            print(self.tableView.frame.minY)
//            print(self.tableView.frame.size.height)
//            print(commentTableView.contentSize.height)
            print("CommentTableFrameHeight is \(commentTableView.frame.size.height)")
            print("CommentTableContainerFrameHeight is \(commentTableContainerView.frame.size.height)")
//            print("ContainerViewFrameHeight is \(containerView.frame.size.height)")
//            print(commentTableContainerView.frame.minY)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == self.tableView) {
            // Create responseTableView
            commentTableContainerView.isHidden = false
            commentTableView.isHidden = false
            let selectedCell = tableView.cellForRow(at: indexPath) as! ReplyTableViewCell
            print(selectedCell)
            CTRVResponseLabel.text = selectedCell.replyLabel.text
            CTRVUserNameLabel.text = selectedCell.userNameLabel.text
            CTRVCreateDateLabel.text = selectedCell.createDate.text
            
            self.responseID = responseArray[indexPath.row].key
            getCommentsOfResponseFromFirebase()
            
            // closure
            showCommentTableView{
                //self.commentTableView.frame.size.height = commentTableView.contentSize.height
                print("Should be after")
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
            touchedResponsePosition = tableView.cellForRow(at: indexPath)?.frame.origin
            //print(tableView.cellForRow(at: indexPath)?.frame.origin.y)
        }
    }
    
    
    // MARK: - Firebase Methods
    
    func getThreadDataFromFirebase() {
        getThreadHeadingInformationFromFirebase()
        getResponsesOfThreadFromFirebase()
    }
    
    func getThreadHeadingInformationFromFirebase() {
        ref.child("threads").child(threadID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                
                let dict = snapshot.value as! [String: Any] // the value is a dict
                
                let subject = dict["subject"] as! String
                let description = dict["description"] as! String
                let creator = dict["creator"] as! String
                let dateCreated = dict["dateCreated"] as! Double // Call date using "var date = NSDate(timeIntervalSince1970: interval)"
                
                self.subjectLabel.text = subject
                self.descriptionLabel.text = description
                self.dateCreatedLabel.text = self.convertIntervalToDateString(interval: dateCreated)
                
                
                self.ref.child("users").child(creator).observeSingleEvent(of: .value, with: { (snap) in
                    if (snap.value is NSNull) {
                        print("not found")
                    } else {
                        let userDict = snap.value as! [String:Any]
                        
                        let creatorName = userDict["name"] as? String
                        
                        self.userNameLabel.text = creatorName!
                    }
                })
            }
        })
    }
    
    func getResponsesOfThreadFromFirebase() {
        var responsesCount: Int = 0
        ref.child("threads").child(threadID!).child("responses").observe(.value) { (snapshot) in
            self.responseArray.removeAll()
            if ( snapshot.value is NSNull ) {
                print("Response not found")
            } else {
                for child in (snapshot.children) {
                    let snap = child as! DataSnapshot //each child is a snapshot
                    let dict = snap.value as! [String: Any] // the value is a dict
                    
                    let responseKey = snap.key
                    let responseString = dict["response"] as! String
                    let userName = dict["userName"] as! String
                    let createDate = dict["createDate"] as! Double
                    
                    let createDateString = self.convertIntervalToDateString(interval: createDate)
                    
                    responsesCount += 1
                    let response = Reply(creatorName: userName, reply: responseString, createDate: createDateString, key: responseKey)
                    self.responseArray.append(response)
                }
            }
            self.tableView.reloadData()
            self.ref.child("threads").child(self.threadID!).child("responseCount").setValue(responsesCount)
        }
        
    }
    
    func getCommentsOfResponseFromFirebase() {
        ref.child("threads").child(threadID!).child("responses").child(responseID!).child("comments").observe(.value) { (snapshot) in
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
                    
                    let createDateString = self.convertIntervalToDateString(interval: createDate)
                    
                    let comment = Reply(creatorName: userName, reply: commentString, createDate: createDateString, key: commentKey)
                    self.commentArray.append(comment)
                }
            }
            self.commentTableView.reloadData()
            print(self.commentTableContainerView.frame.minY)
            print("its here")
        }
    }
    
    
    // MARK: - Button touches
    
    @IBAction func touchedReplyButton(_ sender: Any) {
        performSegue(withIdentifier: "createResponseSegue", sender: self)
        
    }
    
    func convertIntervalToDateString(interval:Double) -> String{
        //print(interval)
        let date = Date(timeIntervalSince1970: interval)
        //print(date)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        //print(formatter.string(from: date))
        return formatter.string(from:date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createResponseSegue" {
            let targetController = segue.destination as! CreateReplyVC
            targetController.threadID = self.threadID
            targetController.isResponse = true
        } else if segue.identifier == "createCommentSegue" {
            let targetController = segue.destination as! CreateReplyVC
            targetController.threadID = self.threadID
            targetController.responseID = self.responseID
            targetController.isResponse = false
        }
    }
    
    @IBAction func replyToResponse(_ sender: Any) {
        performSegue(withIdentifier: "createCommentSegue", sender: self)
    }
    
    @IBAction func exitCommentTable(_ sender: Any) {
        self.commentTableContainerView.isHidden = true
        self.commentTableView.isHidden = true
        self.tableView.isHidden = false
        
        self.tableView.frame.size.height = self.tableView.contentSize.height
        scrollView.contentSize.height = self.tableView.frame.minY + self.tableView.contentSize.height
        //commentTableView.frame.size.height = commentTableView.contentSize.height
        
        UIView.animate(withDuration: 0.5) {
            self.moveDown(view: self.commentTableContainerView)
        }
        scrollView.setContentOffset(touchedResponsePosition!, animated: true)
    }
    
    
    // MARK: - Comments tableView
    
    func showCommentTableView(completionHandler: () -> Void) {
        commentTableView?.delegate = self
        commentTableView?.dataSource = self
        
        //commentTableView.setContentOffset(x, animated: true)
        UIView.animate(withDuration: 0.5, animations: {
            self.moveUp(view: self.commentTableContainerView)
            self.scrollView.setContentOffset(CGPoint.zero, animated: false)
        }) { (true) in
            self.commentTableView.frame.size.height = self.commentTableView.contentSize.height
            self.scrollView.contentSize.height = self.tableView.frame.minY + self.commentTableView.contentSize.height
        }
        
        /*UIView.animate(withDuration: 0.5) {
            self.moveUp(view: self.commentTableContainerView)
        }*/
        self.tableView.isHidden = true
        
        //scrollView.contentSize.height = self.tableView.frame.minY + commentTableView.contentSize.height
        ///commentTableView.frame.size.height = commentTableView.contentSize.height
        
        //print(commentTableView.frame.origin.y)
        //print(commentTableContainerView.frame.origin.y)
        //print("ContainerView height is \(containerView.frame.size.height)")
        print("Should be before")
        completionHandler()
    }
    
    func moveUp(view: UIView) {
        view.frame.origin.y = tableView.frame.minY
    }
    
    func moveDown(view: UIView) {
        view.frame.origin.y = tableView.frame.maxY
    }
    
    
}
