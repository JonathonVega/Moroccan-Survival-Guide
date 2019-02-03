//
//  ThreadVC.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 12/12/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ThreadVC: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var threadID: String?
    var response: Reply?

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var replyToThreadButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var threadHeadingView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    var responseArray = [Reply]()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 200)
        scrollView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        scrollView.bounces = false
        tableView.bounces = false
        tableView.isScrollEnabled = false
        tableView.isHidden = false //Was hidden
        
        replyToThreadButton.isHidden = true
        //checkForCurrentUser()
        
        ref = Database.database().reference()
        getThreadDataFromFirebase()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.containerViewHeight.constant = tableView.frame.minY + tableView.contentSize.height // Adjusts height so eventsTable can be scrolled down
        checkForCurrentUser()
        getResponsesOfThreadFromFirebase()
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
        cell.userNameLabel.text = response.creator
        cell.replyLabel.text = response.reply
        cell.createDate.text = response.dateCreated
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.response = responseArray[indexPath.row]
        
        performSegue(withIdentifier: "toCommentsSegue", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
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
                
                let post = dict["post"] as! String
                let creatorID = dict["creatorID"] as! String
                let dateCreated = dict["dateCreated"] as! Double // Call date using "var date = NSDate(timeIntervalSince1970: interval)"
                self.postLabel.text = post
                self.dateCreatedLabel.text = self.convertIntervalToDateString(interval: dateCreated)
                
                self.ref.child("users").child(creatorID).observeSingleEvent(of: .value, with: { (snap) in
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
            var responsesCount: Int = 0
            self.responseArray.removeAll()
            if ( snapshot.value is NSNull ) {
                print("Response not found")
                if (self.responseArray.isEmpty){
                    self.tableView.isHidden = true
                }
            } else {
                self.tableView.isHidden = false
                for child in (snapshot.children) {
                    let snap = child as! DataSnapshot //each child is a snapshot
                    let dict = snap.value as! [String: Any] // the value is a dict
                    
                    let responseKey = snap.key
                    let responseString = dict["response"] as! String
                    let userName = dict["creatorName"] as! String
                    let dateCreated = dict["dateCreated"] as! Double
                    let creatorKey = dict["creatorID"] as! String
                    
                    let dateCreatedString = self.convertIntervalToDateString(interval: dateCreated)
                    
                    responsesCount += 1
                    let response = Reply(creatorID: creatorKey, creator: userName, reply: responseString, dateCreated: dateCreatedString, key: responseKey)
                    self.responseArray.append(response)
                }
            }
            self.responseArray.reverse()
            self.tableView.reloadData()
            self.ref.child("threads").child(self.threadID!).child("responseCount").setValue(responsesCount)
        }
    }
    
    func checkIfFavorited(){
        if(Auth.auth().currentUser?.uid != nil){
            let userID = Auth.auth().currentUser?.uid
            //ref.child("threads").child(threadID!).observeSingleEvent(of: .value, with: { (snapshot) in
            self.ref.child("users").child(userID!).child("favorites").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(self.threadID!){
                    self.favoriteButton.setImage(UIImage(named: "star-orange"), for: .normal)
                }else {
                    self.favoriteButton.setImage(UIImage(named: "star-gray"), for: .normal)
                }
            })
        }
    }
    
    func favoriteThreadToFirebase() {
        let userID = Auth.auth().currentUser?.uid
        let date = Date().timeIntervalSince1970
        self.ref.child("users").child(userID!).child("favorites").child(threadID!).child("date").setValue(date)
        favoriteButton.setImage(UIImage(named: "star-orange"), for: .normal)
        addFavoriteCountToThread()
    }
    
    func unfavoriteThreadFromFirebase() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).child("favorites").child(threadID!).removeValue()
        favoriteButton.setImage(UIImage(named: "star-gray"), for: .normal)
        minusFavoriteCountToThread()
    }
    
    func addFavoriteCountToThread(){
        self.ref.child("threads").child(threadID!).child("favoritesCount").observeSingleEvent(of: .value, with: { (snapshot) in
            if var favoriteCount = snapshot.value as? Int{
                print("Trying to add a count")
                print(favoriteCount)
                favoriteCount += 1
                self.ref.child("threads").child(self.threadID!).child("favoritesCount").setValue(favoriteCount)
            }else {
                self.ref.child("threads").child(self.threadID!).child("favoritesCount").setValue(1)
            }
        })
    }
    
    func minusFavoriteCountToThread(){
        self.ref.child("threads").child(threadID!).child("favoritesCount").observeSingleEvent(of: .value, with: { (snapshot) in
            if var favoriteCount = snapshot.value as? Int{
                if favoriteCount >= 1 {
                    print("Trying to minus a count")
                    print(favoriteCount)
                    favoriteCount -= 1
                }
                self.ref.child("threads").child(self.threadID!).child("favoritesCount").setValue(favoriteCount)
            }else {
                print("No Response")
            }
        })
    }
    
    
    
    // MARK: - Button touches
    
    @IBAction func touchedFavoriteButton(_ sender: Any) {
        if(favoriteButton.currentImage == UIImage(named: "star-gray")){
            favoriteThreadToFirebase()
        }else if(favoriteButton.currentImage == UIImage(named: "star-orange")){
            unfavoriteThreadFromFirebase()
        }
    }
    
    @IBAction func touchedReplyButton(_ sender: Any) {
        performSegue(withIdentifier: "createResponseSegue", sender: self)
    }
    
    func checkForCurrentUser() {
        if Auth.auth().currentUser != nil {
            self.replyToThreadButton.isHidden = false
            self.replyToThreadButton.isEnabled = true
            self.favoriteButton.isHidden = false
            checkIfFavorited()
        } else {
            self.replyToThreadButton.isHidden = false
            self.replyToThreadButton.isEnabled = false
            self.favoriteButton.isHidden = true
        }
    }
    
    func convertIntervalToDateString(interval:Double) -> String{
        let date = Date(timeIntervalSince1970: interval)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
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
}
