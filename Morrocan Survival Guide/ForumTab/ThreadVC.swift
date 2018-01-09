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
    var response: Reply?

    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var threadHeadingView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    var responseArray = [Reply]()
    
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
        
        ref = Database.database().reference()
        
        getThreadDataFromFirebase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.containerViewHeight.constant = tableView.frame.minY + tableView.contentSize.height // Adjusts height so eventsTable can be scrolled down
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
        count = responseArray.count
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "response", for: indexPath) as! ReplyTableViewCell
        
        let response = responseArray[indexPath.row]
        cell.userNameLabel.text = response.creatorName
        cell.replyLabel.text = response.reply
        cell.createDate.text = response.createDate
        
        //commentTableContainerView.frame.size.height = /*tableView.frame.minY +*/ commentTableView.contentSize.height
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let selectedCell = tableView.cellForRow(at: indexPath) as! ReplyTableViewCell
        
        self.response = responseArray[indexPath.row]
        
        ////responseHeaderView.frame.size.height = 60 + (tableView.cellForRow(at: indexPath)?.frame.size.height)!
        
        performSegue(withIdentifier: "toCommentsSegue", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        touchedResponsePosition = scrollView.contentOffset//tableView.cellForRow(at: indexPath)?.frame.origin
        //print(tableView.cellForRow(at: indexPath)?.frame.origin.y)
        
        
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
            targetController.responseID = self.response?.key
            targetController.isResponse = false
        } else if segue.identifier == "toCommentsSegue" {
            let targetController = segue.destination as! CommentsVC
            targetController.threadID = self.threadID
            targetController.response = self.response
        }
    }
    
    @IBAction func replyToResponse(_ sender: Any) {
        performSegue(withIdentifier: "createCommentSegue", sender: self)
    }
    
}
