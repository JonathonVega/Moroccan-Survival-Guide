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

class ForumTableVC: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var createThreadBarButton: UIBarButtonItem!
    
    var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 440, height: 40))
    
    var ThreadsArray = [ThreadHeading]()
    //var filteredData = [ThreadHeading]()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Auto corrects height of cells
        setColors()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        searchBar.placeholder = "Search"
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
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
        
        cell.responseCountLabel.text = String(describing: Thread.responseCount!)
        cell.responseCountLabel.adjustsFontSizeToFitWidth = true

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
    
    
    // MARK: - Firebase Calls
    
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
                    let dict = snap.value as! [String: Any] // the value is a dict
                    
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
                    
                    self.ThreadsArray.append(Thread!)
                }
            }
            self.ThreadsArray.reverse()
            self.tableView.reloadData()
            
        }
    }
    
    func getFilteredThreads(searchText: String) {
        var filteredData = [ThreadHeading]()
        if searchText == "" {
            getRecentDataFromFirebase()
            
        } else {
            ref.child("threads").observeSingleEvent(of: .value) { (snapshot) in
                if ( snapshot.value is NSNull ) {
                    print("not found")
                } else {
                    
                    for child in (snapshot.children) {
                        
                        let snap = child as! DataSnapshot //each child is a snapshot
                        let dict = snap.value as! [String: Any] // the value is a dict
                        
                        let threadID = snap.key
                        let subject = dict["subject"] as! String
                        let description = dict["description"] as! String
                        let creator = dict["creator"] as! String
                        let Thread: ThreadHeading?
                        
                        if dict["responseCount"] != nil {
                            let responseCount = dict["responseCount"] as! Int
                            print(responseCount)
                            
                            if ((subject.lowercased().range(of: searchText) != nil) || (description.lowercased().range(of: searchText) != nil)) {
                                Thread = ThreadHeading(subject: subject, description: description, creator: creator, threadID: threadID, responseCount: responseCount)
                                filteredData.append(Thread!)
                            }
                            
                        } else if ((subject.lowercased().range(of: searchText) != nil) || (description.lowercased().range(of: searchText) != nil)) {
                            if ((subject.lowercased().range(of: searchText) != nil) || (description.lowercased().range(of: searchText) != nil)) {
                                Thread = ThreadHeading(subject: subject, description: description, creator: creator, threadID: threadID, responseCount: 0)
                                filteredData.append(Thread!)
                            }
                        }
                    }
                }
                print("Filtered")
                print(filteredData)
                self.ThreadsArray = filteredData
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Search Bar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Hide search bar
        self.searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        // Filter through data
        let searchText = searchBar.text?.lowercased()
        getFilteredThreads(searchText: searchText!)
        print("cool")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        //searchBar.text = ""
        // Hide the cancel button
        //searchBar.showsCancelButton = false
        // You could also change the position, frame etc of the searchBar
        self.searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.enablesReturnKeyAutomatically = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.searchBar.endEditing(true)
    }
    
    
    // MARK: - Other methods
    
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
        navigationController?.navigationBar.barTintColor = UIColor(red:229/255, green:167/255, blue:53/255, alpha:1.0)
        navigationController?.navigationBar.tintColor = UIColor(red: 73/255, green: 119/255, blue: 210/255, alpha: 1.0)
    }
    
    // 73 119 210
    
    
}
