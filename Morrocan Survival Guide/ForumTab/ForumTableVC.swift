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
import Flurry_iOS_SDK

class ForumTableVC: UITableViewController, UISearchBarDelegate, FlurryAdNativeDelegate {
    
    @IBOutlet weak var createThreadBarButton: UIBarButtonItem!
    
    var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 440, height: 40))
    
    var ThreadsArray = [ThreadHeading]()
    
    var ref: DatabaseReference!
    
    
    // MARK: - Flurry Ad Variables
    
    var pendingAdList: [FlurryAdNative] = []
    var nativeAdList: [FlurryAdNative] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    //let nativeAd = FlurryAdNative(space: "ADSPACE")
    var nativeAdsWanted = 3
    
    //how many posts we want on startup and how many we want to load when the user gets to the end of the feed
    let initialPostsWanted = 9
    let additionalPostsToGet = 6
    
    //how many times we want to retry fetching ads and a count that makes sure we don't go over this
    let adFetchRetryMaximum = 10
    var adFetchRetryCount = 0
    
    //this keeps track of what post index we are at so that we dont pull the same posts from Tumblr
    var postIndex = 0
    
    //this string will be updated to a location when the user clicks a post cell and then passed to the map view controller
    var locationToPass = ""
    
    // this bool will be true when we are not currently waiting on posts and false if we are
    var shouldGetPosts = true
    
    
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
        
        /*nativeAd?.adDelegate = self
        nativeAd?.viewControllerForPresentation = self
        nativeAd?.fetchAd()*/
        setupAds()
        
        getRecentDataFromFirebase()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return ThreadsArray.count + nativeAdList.count
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
        
        if indexPath.section % 5 == 0 && nativeAdList.count > indexPath.section / 5 {
            let cellIndex = indexPath.section/5
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "adCell") as! AdTableCell
            
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            
            cell.nativeAd = nativeAdList[cellIndex]
            
            self.nativeAdList[cellIndex].trackingView = cell
            
            //if let assets = nativeAdList[cellIndex].assetList {
            if let assets = cell.nativeAd.assetList {
                for asset in assets {
                    switch((asset as! FlurryAdNativeAsset).name) {
                    case "headline":
                        cell.adTitleLabel.text = (asset as! FlurryAdNativeAsset).value
                    case "summary":
                        cell.adBodyLabel.text = (asset as! FlurryAdNativeAsset).value
                    case "secHqImage":
                        if let url = URL(string: (asset as! FlurryAdNativeAsset).value) {
                            if let imageData = NSData(contentsOf: url) {
                                let image = UIImage(data: imageData as Data)
                                cell.adIconImageView.image = image
                            }
                        }
                    case "source":
                        //cell.
                        print("cool")
                    case "secHqBrandingLogo":
                        if let url = URL(string: (asset as! FlurryAdNativeAsset).value) {
                            if let imageData = NSData(contentsOf: url) {
                                print(imageData)
                            }
                        }
                    default:()
                    }
                }
            }
            print("adCell returned")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Thread", for: indexPath) as! ThreadTableViewCell
            
            //let Thread = ThreadsArray[indexPath.section]
            let Thread = ThreadsArray[indexPath.section]
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
    
    
    // MARK: - Flurry Ad Methods
    
    @objc func setupAds() {
        var newAdsList : [FlurryAdNative] = []
        
        //only get new ads if we want at least one
        if nativeAdsWanted >= 1 {
            for _ in 1...nativeAdsWanted {
                let nativeAd = FlurryAdNative(space: "streamy")
                
                //            // uncomment to make these ads test ads (should enable 100% fill)
                //            let adTargeting = FlurryAdTargeting()
                //            adTargeting.testAdsEnabled = true
                //            nativeAd.targeting = adTargeting
                
                //setting the ad delegate a view controller
                nativeAd?.adDelegate  = self
                nativeAd?.viewControllerForPresentation = self
                
                //fetching the ad from Flurry and then addding it to our list of new ads
                nativeAd?.fetchAd()
                newAdsList.append(nativeAd!)
            }
        }
        
        //updating our ad list to be our new ad list
        pendingAdList = newAdsList
    }
    
    func adNativeDidFetchAd(_ nativeAd: FlurryAdNative!) {
        NSLog("Native Ad for Space \(nativeAd.space) Received Ad with \(nativeAd.assetList.count) assets")
        nativeAdsWanted = nativeAdsWanted - 1
        
        //every time an ad is fetched this checks to see if there are any ready ads
        for ad in pendingAdList {
            if ad.ready {
                if let i = pendingAdList.index(of: ad) {
                    pendingAdList.remove(at: i)
                    nativeAdList.append(ad)
                } else {
                    print ("index in pending list does not exist")
                }
            }
        }
    }
    
    func adNative(_ nativeAd: FlurryAdNative!, adError: FlurryAdError, errorDescription: Error!) {
        NSLog("Native Ad for Space \(nativeAd.space) Received Error \(adError), with description: \(errorDescription)")
        
        if adFetchRetryCount < adFetchRetryMaximum {
            let selector: Selector = #selector(setupAds)
            _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: selector, userInfo: nil, repeats: false)
        } else { print (("AD FETCH FAILED"))
            
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
