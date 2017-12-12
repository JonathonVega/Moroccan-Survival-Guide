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

    var ThreadsArray = [ThreadHeading]()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        cell.subjectLabel.adjustsFontSizeToFitWidth = true
        
        cell.descriptionLabel.text = Thread.description
        cell.descriptionLabel.adjustsFontSizeToFitWidth = true
        cell.descriptionLabel.numberOfLines = 0

        return cell
    }
    
    /*override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = calculateHeightForString(inString: ThreadsArray[indexPath.row].description!)
        return height + 70.0
    }*/
    
    func checkForCurrentUser() {
        if Auth.auth().currentUser != nil {
            // TODO: Include design if not signed in
        }
    }
    
    func getRecentDataFromFirebase() {
        ref.child("ForumThreads").observeSingleEvent(of: .value) { (snapshot) in
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                
                for child in (snapshot.children) {
                    
                    let snap = child as! DataSnapshot //each child is a snapshot
                    let dict = snap.value as! [String: Any] // the value is a dict
                    
                    let subject = dict["Subject"] as! String
                    let description = dict["Description"] as! String
                    let creator = dict["Creator"] as! String
                    
                    let Thread = ThreadHeading(subject: subject, description: description, creator: creator)
                    self.ThreadsArray.append(Thread)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    /*func calculateHeightForString(inString:String) -> CGFloat {
        let messageString = inString
        let attributes : [String : Any] = [NSFontAttributeName : UIFont.systemFont(ofSize: 15.0)]
        
        let attributedString : NSAttributedString = NSAttributedString(string: messageString, attributes: attributes)
        
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width: 222.0, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        let requredSize:CGRect = rect
        return requredSize.height
    }*/


}
