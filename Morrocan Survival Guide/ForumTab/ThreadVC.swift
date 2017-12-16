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
    
    var responseTableView: UITableView?
    
    var responseArray = [Response]()
    //var commentArray: [Comment]()
    
    let screenHeight = UIScreen.main.bounds.height//UIScreen.main.Screen().bounds.height
    let scrollViewContentHeight = 900 as CGFloat
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 787)
        scrollView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        scrollView.bounces = false
        tableView.bounces = false
        tableView.isScrollEnabled = false
        tableView.isHidden = true
        ref = Database.database().reference()
        
        getThreadDataFromFirebase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.containerViewHeight.constant = tableView.frame.minY + tableView.contentSize.height // Adjusts height so eventsTable can be scrolled down
        tableView.isHidden = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupThreadHeading() {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if scrollView == self.scrollView {
            if yOffset > 0 {//yOffset >= scrollViewContentHeight - screenHeight {
                //print("It hits this")
            }
        }

        self.containerViewHeight.constant = self.tableView.frame.minY + self.tableView.contentSize.height // Adjusts height so eventsTable can be scrolled down
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == self.tableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "response", for: indexPath) as! ReplyTableViewCell
            
            let response = responseArray[indexPath.row]
            cell.userNameLabel.text = response.creatorName
            cell.responseLabel.text = response.response
            cell.createDate.text = response.createDate
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "response", for: indexPath) as! ReplyTableViewCell
            return cell
        }
        
        
        // Configure the cell...
        
        
        
        //self.containerViewHeight.constant = tableView.frame.minY + tableView.contentSize.height // Adjusts height so eventsTable can be scrolled down
        //print("containerViewHeight \(self.containerViewHeight.constant)")
        //print("tableView.frame.minY \(self.tableView.frame.minY)")
        //print("tableView.contentsize.height \(self.tableView.contentSize.height)")
        //self.tableView.frame.size.height = self.tableView.frame.minY + self.containerView.frame.maxY
        

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == self.tableView) {
            // Create responseTableView
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
        ref.child("threads").child(threadID!).child("responses").observe(.value) { (snapshot) in
            self.responseArray.removeAll()
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                
                for child in (snapshot.children) {
                    let snap = child as! DataSnapshot //each child is a snapshot
                    let dict = snap.value as! [String: Any] // the value is a dict
                    
                    let responseString = dict["response"] as! String
                    let userName = dict["userName"] as! String
                    let createDate = dict["createDate"] as! Double
                    
                    let createDateString = self.convertIntervalToDateString(interval: createDate)
                    
                    let response = Response(creatorName: userName, response: responseString, createDate: createDateString)
                    self.responseArray.append(response)
                }
            }
            self.tableView.reloadData()
        }
        
    }
    
    func getCommentsOfResponseFromFirebase() {
        ref.child("responses").child(threadID!).observe(.value) { (snapshot) in
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
        }
    }
    
    // MARK: - Button touches
    
    @IBAction func touchedReplyButton(_ sender: Any) {
        performSegue(withIdentifier: "createReplySegue", sender: self)
    }
    
    func convertIntervalToDateString(interval:Double) -> String{
        print(interval)
        let date = Date(timeIntervalSince1970: interval)
        print(date)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        print(formatter.string(from: date))
        return formatter.string(from:date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createReplySegue" {
            let targetController = segue.destination as! CreateReplyVC
            targetController.threadID = self.threadID
            targetController.isResponse = true
        }
    }
    
    @IBAction func replyToResponse(_ sender: Any) {
        performSegue(withIdentifier: "createReplySegue", sender: self)
    }
    
}
