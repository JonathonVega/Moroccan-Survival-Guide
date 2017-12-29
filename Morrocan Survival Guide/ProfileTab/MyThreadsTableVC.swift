//
//  MyThreadsTableVC.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 12/27/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class MyThreadsTableVC: UITableViewController {

    var threadsArray = [ThreadHeading]()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        ref = Database.database().reference()
        getMyThreadsFromFirebase()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return threadsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyThreadCell", for: indexPath) as! ThreadTableViewCell

        let Thread = threadsArray[indexPath.row]
        cell.subjectLabel.text = Thread.subject
        cell.subjectLabel.adjustsFontSizeToFitWidth = false
        cell.subjectLabel.numberOfLines = 0
        
        cell.descriptionLabel.text = Thread.description
        cell.descriptionLabel.adjustsFontSizeToFitWidth = false
        cell.descriptionLabel.numberOfLines = 4
        
        cell.responseCountLabel.text = String(describing: Thread.responseCount!)
        cell.responseCountLabel.adjustsFontSizeToFitWidth = true
        
        cell.threadID = Thread.threadID

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueToThread", sender: self)
        
    }
    
    
    // MARK: - Firebase Call Methods
    
    func getMyThreadsFromFirebase() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).child("threads").observeSingleEvent(of: .value) { (snapshot) in
            var userThreadsArray = [String]()
            for child in (snapshot.children) {
                let snap =  child as! DataSnapshot
                let threadID = snap.key
                userThreadsArray.append(threadID)
            }
            self.getUserThreadsArray(userThreadsIDArray: userThreadsArray)
            
        }
    }
    
    func getUserThreadsArray(userThreadsIDArray: [String]) {
        self.ref.child("threads").observeSingleEvent(of: .value, with: { (snapshot) in
            var userThreadsArray = [ThreadHeading]()
            for child in (snapshot.children) {
                let snap = child as! DataSnapshot
                let threadID = snap.key
                if(userThreadsIDArray.contains(threadID)) {
                    let dict = snap.value as! [String: Any]
                    
                    let subject = dict["subject"] as! String
                    let description = dict["description"] as! String
                    let creator = dict["creator"] as! String
                    let Thread: ThreadHeading?
                    
                    if dict["responseCount"] != nil {
                        let responseCount = dict["responseCount"] as! Int
                        print(responseCount)
                        Thread = ThreadHeading(subject: subject, description: description, creator: creator, threadID: threadID, responseCount: responseCount)
                    } else {
                        Thread = ThreadHeading(subject: subject, description: description, creator: creator, threadID: threadID, responseCount: 0)
                    }
                    
                    //let Thread = ThreadHeading(subject: subject, description: description, creator: creator, threadID: threadID, responseCount: responseCount)
                    
                    userThreadsArray.append(Thread!)
                }
                
            }
            self.threadsArray = userThreadsArray
            self.threadsArray.reverse()
            self.tableView.reloadData()
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToThread" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let currentCell = tableView.cellForRow(at: indexPath) as! ThreadTableViewCell
                let targetController = segue.destination as! ThreadVC
                targetController.threadID = currentCell.threadID
            }
        }
    }
    
    
    
}
