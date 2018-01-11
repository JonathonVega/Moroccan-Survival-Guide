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
import FBAudienceNetwork

class ForumTableVC: UITableViewController, UISearchBarDelegate, FBNativeAdDelegate, FBNativeAdsManagerDelegate {
    
    @IBOutlet weak var createThreadBarButton: UIBarButtonItem!
    
    var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 440, height: 40))
    
    var ThreadsArray = [ThreadHeading]()
    
    var ref: DatabaseReference!
    
    
    // MARK: - FB Ads Variables
    
    let adRowStep = 5
    var adsManager: FBNativeAdsManager!
    var adsCellProvider: FBNativeAdTableViewCellProvider!
    
    
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
        
        adsManager = FBNativeAdsManager(placementID: "709414042582846_709420665915517", forNumAdsRequested: 3)
        adsManager.delegate = self
        adsManager.loadAds()
        
        getRecentDataFromFirebase()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return ThreadsArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if adsCellProvider != nil {
            return Int(adsCellProvider.adjustCount(UInt(ThreadsArray.count), forStride: UInt(adRowStep)))
        } else {
            return 1
        }
        //return 1
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
        
        if adsCellProvider != nil && adsCellProvider.isAdCell(at: indexPath, forStride: UInt(adRowStep)) {
            // Put ad code here
            print("Is it here by chance?")
            let ad = adsManager.nextNativeAd
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ad", for: indexPath) as! AdTableCell
            cell.adBodyLabel.text = ad?.body
            cell.adTitleLabel.text = ad?.title
            cell.adCallToActionButton.setTitle(ad?.callToAction, for: .normal)
            if let pic = ad?.coverImage {
                cell.adIconImageView.image = downloadImage(url: pic.url)  //(urlString: pic.url.absoluteString)
            }
            ad?.registerView(forInteraction: cell, with: self)
            
            return cell
        } else {
            // Return a normal cell
            // Use tableData[indexPath.row - Int(indexPath.row / adRowStep)] to get the row this would have normally been without the ad
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Thread", for: indexPath) as! ThreadTableViewCell
            
            //let Thread = ThreadsArray[indexPath.section]
            let Thread = ThreadsArray[indexPath.section - Int(indexPath.section / adRowStep)]
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
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueToThread", sender: self)
        
        
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
    
    
    // MARK: - FB Ads Methods
    
    func nativeAdsLoaded() {
        adsCellProvider = FBNativeAdTableViewCellProvider(manager: adsManager, for: FBNativeAdViewType.genericHeight300)
        adsCellProvider.delegate = self
        if self.tableView != nil {
            self.tableView.reloadData()
        }
    }
    
    func nativeAdsFailedToLoadWithError(_ error: Error) {
        print(error)
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
        self.searchBar.endEditing(true)
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
    
    func downloadImage(url: URL) -> UIImage {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                return UIImage(data: data)
            }
        }
        return UIImage()
    }
    
    func setColors() {
        navigationController?.navigationBar.barTintColor = UIColor(red:229/255, green:167/255, blue:53/255, alpha:1.0)
        navigationController?.navigationBar.tintColor = UIColor(red: 73/255, green: 119/255, blue: 210/255, alpha: 1.0)
    }
    
    // 73 119 210
    
    
}
