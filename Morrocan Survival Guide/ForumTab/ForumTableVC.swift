//
//  ForumTableVC.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 11/3/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ForumTableVC: UITableViewController {

    @IBOutlet weak var createThreadBarButton: UIBarButtonItem!
    var ThreadsArray = [ThreadHeading]()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Auto corrects height of cells
        setColors()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        ref = Database.database().reference()
        
        getRecentDataFromFirebase()
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
        return ThreadsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Thread", for: indexPath) as! ThreadTableViewCell
        
        let Thread = ThreadsArray[indexPath.row]
        cell.subjectLabel.text = Thread.subject
        cell.subjectLabel.adjustsFontSizeToFitWidth = false
        cell.subjectLabel.numberOfLines = 0
        
        cell.descriptionLabel.text = Thread.description
        cell.descriptionLabel.adjustsFontSizeToFitWidth = false
        cell.descriptionLabel.numberOfLines = 4

        cell.threadID = Thread.threadID

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueToThread", sender: self)
        
        //let currentCell = tableView.cellForRow(at: indexPath) as! ThreadTableViewCell
        
    }
    
    func checkForCurrentUser() {
        if Auth.auth().currentUser != nil {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            self.navigationItem.rightBarButtonItem = self.createThreadBarButton
        }
    }
    
    func getRecentDataFromFirebase() {
        ref.child("threads").observe(.value) { (snapshot) in
            self.ThreadsArray.removeAll()
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                
                for child in (snapshot.children) {
                    
                    let snap = child as! DataSnapshot //each child is a snapshot
                    let threadID = snap.key
                    print(threadID)
                    print("Did we get it")
                    let dict = snap.value as! [String: Any] // the value is a dict
                    
                    let subject = dict["subject"] as! String
                    let description = dict["description"] as! String
                    let creator = dict["creator"] as! String

                    let Thread = ThreadHeading(subject: subject, description: description, creator: creator, threadID: threadID)
                    
                    self.ThreadsArray.append(Thread)
                }
            }
            self.ThreadsArray.reverse()
            self.tableView.reloadData()
            
        }
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
    
    func setColors() {
        navigationController?.navigationBar.barTintColor = UIColor(red:178/255, green:135/255, blue:54/255, alpha:1.0)
    }
}
