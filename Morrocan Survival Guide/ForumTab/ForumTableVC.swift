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
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var createThreadBarButton: UIBarButtonItem!
    
    var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 440, height: 40))
    
    var threadsArray = [ThreadHeading]()
    
    var ref: DatabaseReference!
    
    var numberOfPosts: Int = 20
    
    var startKey: String!
    
    var allowPagination = true
    
    
    // MARK: - Default Methods
    
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
        
        //getRecentDataFromFirebase()
        
        //handleDataPagination()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("The view is showing")
        handleDataPagination()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - Table view data source
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maxOffset - currentOffset <= 40{
            handleDataPagination()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return threadsArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
        return footer
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Thread", for: indexPath) as! ThreadTableViewCell
        
        let Thread = threadsArray[indexPath.section]
        
        cell.postLabel.text = Thread.post
        cell.postLabel.adjustsFontSizeToFitWidth = false
        cell.postLabel.numberOfLines = 4
        
        cell.userNameLabel.text = Thread.creator
        cell.responseCountLabel.text = String(describing: Thread.responseCount!)
        cell.responseCountLabel.adjustsFontSizeToFitWidth = true
        
        cell.threadID = Thread.threadID
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueToThread", sender: self)
        
    }
    
    
    // MARK: - Firebase Calls
    
    func getRecentDataFromFirebase() {
        ref.child("threads").observeSingleEvent(of: .value) { (snapshot) in
            self.threadsArray.removeAll()
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                for child in (snapshot.children) {
                    
                    let snap = child as! DataSnapshot //each child is a snapshot
                    let threadID = snap.key
                    let dict = snap.value as! [String: Any] // the value is a dict
                    
                    let post = dict["post"] as! String
                    let creator = dict["creator"] as! String
                    let creatorID = dict["creatorID"] as! String
                    let Thread: ThreadHeading?
                    
                    if dict["responseCount"] != nil {
                        let responseCount = dict["responseCount"] as! Int
                        Thread = ThreadHeading(post: post, creator: creator, creatorID:creatorID, threadID: threadID, responseCount: responseCount)
                        self.threadsArray.append(Thread!)
                    } else if dict["responseCount"] == nil && dict["post"] != nil{
                        Thread = ThreadHeading(post: post, creator: creator, creatorID:creatorID, threadID: threadID, responseCount: 0)
                        self.threadsArray.append(Thread!)
                    }
                }
            }
            self.threadsArray.reverse()
            self.tableView.reloadData()
        }
    }
    
    func handleDataPagination() {
        let threadRef = Database.database().reference(withPath:"threads").queryOrderedByKey()
        
        if startKey == nil && allowPagination == true{
            threadRef.queryLimited(toLast:10).observeSingleEvent(of: .value, with: {snapshot in
                guard let children = snapshot.children.allObjects.first as? DataSnapshot else{return}
                
                if snapshot.childrenCount > 0 {
                    for child in snapshot.children.allObjects as! [DataSnapshot] {
                        guard let dictionary = child.value as? [String:Any] else{return}
                        
                        let threadID = child.key
                        let post = dictionary["post"] as! String
                        let creator = dictionary["creator"] as! String
                        let creatorID = dictionary["creatorID"] as! String
                        if dictionary["responseCount"] != nil {
                            let responseCount = dictionary["responseCount"] as! Int
                            self.threadsArray.append(ThreadHeading(post: post, creator: creator, creatorID: creatorID, threadID: threadID, responseCount: responseCount))
                        } else if dictionary["responseCount"] == nil && dictionary["post"] != nil{
                            self.threadsArray.append(ThreadHeading(post: post, creator: creator, creatorID: creatorID, threadID: threadID, responseCount: 0))
                        }
                        
                    }
                    self.startKey = children.key
                    print(self.startKey)
                    print("Ok")
                    self.threadsArray.reverse()
                    self.tableView.reloadData()
                }
            })
        } else {
            if(!allowPagination){
                return
            }
            threadRef.queryEnding(atValue:self.startKey).queryLimited(toLast: 11).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let children = snapshot.children.allObjects.first as? DataSnapshot else {return}
                let arrayEnd = self.threadsArray.count
                if snapshot.childrenCount > 0 {
                    for child in snapshot.children.allObjects as! [DataSnapshot] {
                        if child.key != self.startKey{
                            
                            guard let dictionary = child.value as? [String:Any] else {return}
                            
                            let threadID = child.key
                            let post = dictionary["post"] as! String
                            let creator = dictionary["creator"] as! String
                            let creatorID = dictionary["creatorID"] as! String
                            
                            if dictionary["responseCount"] != nil {
                                let responseCount = dictionary["responseCount"] as! Int
                                self.threadsArray.insert(ThreadHeading(post: post, creator: creator, creatorID: creatorID, threadID: threadID, responseCount: responseCount), at: arrayEnd)
                            } else if dictionary["responseCount"] == nil && dictionary["post"] != nil{
                                self.threadsArray.insert(ThreadHeading(post: post, creator: creator, creatorID: creatorID, threadID: threadID, responseCount: 0), at: arrayEnd)
                            }
                        }
                    }
                    self.startKey = children.key
                }
                self.tableView.reloadData()
            })
        }
    }
    
    func getFilteredThreads(searchText: String) {
        var filteredData = [ThreadHeading]()
        if searchText == "" {
            //getRecentDataFromFirebase()
            handleDataPagination()
            
        } else {
            ref.child("threads").queryLimited(toLast: 31).observeSingleEvent(of: .value) { (snapshot) in
                if ( snapshot.value is NSNull ) {
                    print("not found")
                } else {
                    
                    for child in (snapshot.children) {
                        
                        let snap = child as! DataSnapshot //each child is a snapshot
                        let dict = snap.value as! [String: Any] // the value is a dict
                        
                        let threadID = snap.key
                        let post = dict["post"] as! String
                        let creator = dict["creator"] as! String
                        let creatorID = dict["creatorID"] as! String
                        let Thread: ThreadHeading?
                        
                        if dict["responseCount"] != nil {
                            let responseCount = dict["responseCount"] as! Int
                            
                            if (post.lowercased().range(of: searchText) != nil) {
                                Thread = ThreadHeading(post: post, creator: creator, creatorID: creatorID, threadID: threadID, responseCount: responseCount)
                                filteredData.append(Thread!)
                            }
                            
                        } else if (post.lowercased().range(of: searchText) != nil) {
                            if (post.lowercased().range(of: searchText) != nil) {
                                Thread = ThreadHeading(post: post, creator: creator, creatorID: creatorID, threadID: threadID, responseCount: 0)
                                filteredData.append(Thread!)
                            }
                        }
                    }
                }
                self.threadsArray = filteredData
                self.threadsArray.reverse()
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
        allowPagination = false
        getFilteredThreads(searchText: searchText!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        //getRecentDataFromFirebase()
        allowPagination = true
        self.startKey = nil
        handleDataPagination()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.enablesReturnKeyAutomatically = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.searchBar.endEditing(true)
    }
    
    
    
    
    // MARK: - UIButton Actions
    
    @IBAction func addNewThread(_ sender: Any) {
        
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "createThreadSegue", sender: self)
            self.startKey = nil
            self.threadsArray.removeAll()
        } else {
            let alert = UIAlertController(title: "Not signed in", message: "You must be signed in to reply and add new threads.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    // MARK: - Other methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToThread" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let currentCell = tableView.cellForRow(at: indexPath) as! ThreadTableViewCell
                let targetController = segue.destination as! ThreadVC
                targetController.threadID = currentCell.threadID
            }
            
        } else if segue.identifier == "createThreadSegue" {
            
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func setColors() {
        navigationController?.navigationBar.barTintColor = UIColor(red:15/255, green:166/255, blue:185/255, alpha:1.0)
        navigationController?.navigationBar.tintColor = UIColor(red: 49/255, green:12/255, blue:117/255, alpha: 1.0)
    }
    
    // 73 119 210
    
    
}
