//
//  ProfileVC.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 9/11/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var notSignedInWarningLabel: UILabel!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var signInButtonView: UIView!
    
    var myThreadsArray = [ThreadHeading]()
    var favoriteThreadsArray = [ThreadHeading]()
    
    var ref: DatabaseReference!
    var storage: Storage!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupUIBar()
        setColors()
        ref = Database.database().reference()
        storage = Storage.storage()
        checkForCurrentUser()
        //profileImage.layer.borderWidth = 1.0
        //profileImage.layer.borderColor = UIColor.gray.cgColor
        
        imagePicker.delegate = self
        
        //self.view.backgroundColor = UIColor.lightGray
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkForCurrentUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkForCurrentUser() {
        if Auth.auth().currentUser != nil {
            nameLabel.isHidden = false
            signInButtonView.isHidden = true
            notSignedInWarningLabel.isHidden = true
            signInButton.isHidden = true
            menuBarButton.isEnabled = true
            getProfileDataFromFirebase()
            getMyThreadsFromFirebase()
            getUserFavorites()
            
        } else {
            self.signInButton.isHidden = false
            nameLabel.isHidden = true
            signInButtonView.isHidden = false
            notSignedInWarningLabel.isHidden = false
            signInButton.isHidden = false
            menuBarButton.isEnabled = false
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if(segmentedControl.selectedSegmentIndex == 0){
            return 1
        } else if(segmentedControl.selectedSegmentIndex == 1){
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(segmentedControl.selectedSegmentIndex == 0){
            return myThreadsArray.count
        } else if(segmentedControl.selectedSegmentIndex == 1){
            return favoriteThreadsArray.count
        }
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "threadCell", for: indexPath) as! ThreadTableViewCell
        if(segmentedControl.selectedSegmentIndex == 0){
            let Thread = myThreadsArray[indexPath.row]
            cell.deleteButton.isHidden = false
            cell.postLabel.text = Thread.post
            cell.postLabel.adjustsFontSizeToFitWidth = false
            cell.postLabel.numberOfLines = 4
            
            cell.responseCountLabel.text = String(describing: Thread.responseCount!)
            cell.responseCountLabel.adjustsFontSizeToFitWidth = true
            
            cell.threadID = Thread.threadID
            
            return cell
        } else if(segmentedControl.selectedSegmentIndex == 1){
            let Thread = favoriteThreadsArray[indexPath.row]
            cell.deleteButton.isHidden = true
            cell.postLabel.text = Thread.post
            cell.postLabel.adjustsFontSizeToFitWidth = false
            cell.postLabel.numberOfLines = 4
            
            cell.responseCountLabel.text = String(describing: Thread.responseCount!)
            cell.responseCountLabel.adjustsFontSizeToFitWidth = true
            
            cell.threadID = Thread.threadID
            
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueToThread", sender: self)
        
    }
    
    
    // MARK: - Firebase Calls Methods
    
    func getProfileDataFromFirebase() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            self.nameLabel.text = name
        })
    }
    
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
        self.ref.child("threads").observeSingleEvent(of: .value) { (snapshot) in
            var userThreadsArray = [ThreadHeading]()
            for child in (snapshot.children) {
                let snap = child as! DataSnapshot
                let threadID = snap.key
                if(userThreadsIDArray.contains(threadID)) {
                    let dict = snap.value as! [String: Any]
                    
                    let post = dict["post"] as! String
                    let creator = dict["creator"] as! String
                    let creatorID = dict["creatorID"] as! String
                    let Thread: ThreadHeading?
                    
                    if dict["responseCount"] != nil {
                        let responseCount = dict["responseCount"] as! Int
                        Thread = ThreadHeading(post: post, creator: creator, creatorID: creatorID, threadID: threadID, responseCount: responseCount)
                    } else {
                        Thread = ThreadHeading(post: post, creator: creator, creatorID: creatorID, threadID: threadID, responseCount: 0)
                    }
                    
                    userThreadsArray.append(Thread!)
                }
                
            }
            self.myThreadsArray = userThreadsArray
            self.myThreadsArray.reverse()
            self.tableView.reloadData()
        }
    }
    
    func getUserFavorites() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).child("favorites").observeSingleEvent(of: .value) { (snapshot) in
            var favoriteThreadsArray = [String]()
            for child in (snapshot.children) {
                let snap =  child as! DataSnapshot
                let threadID = snap.key
                favoriteThreadsArray.append(threadID)
            }
            self.getUserFavoritesArray(userThreadsIDArray: favoriteThreadsArray)
            
        }
    }
    
    func getUserFavoritesArray(userThreadsIDArray: [String]) {
        self.ref.child("threads").observeSingleEvent(of: .value) { (snapshot) in
            var favoritesArray = [ThreadHeading]()
            for child in (snapshot.children) {
                let snap = child as! DataSnapshot
                let threadID = snap.key
                if(userThreadsIDArray.contains(threadID)) {
                    let dict = snap.value as! [String: Any]
                    
                    let post = dict["post"] as! String
                    let creator = dict["creator"] as! String
                    let creatorID = dict["creatorID"] as! String
                    let Thread: ThreadHeading?
                    
                    if dict["responseCount"] != nil {
                        let responseCount = dict["responseCount"] as! Int
                        Thread = ThreadHeading(post: post, creator: creator, creatorID: creatorID, threadID: threadID, responseCount: responseCount)
                    } else {
                        Thread = ThreadHeading(post: post, creator: creator, creatorID: creatorID, threadID: threadID, responseCount: 0)
                    }
                    
                    favoritesArray.append(Thread!)
                }
                
            }
            self.favoriteThreadsArray = favoritesArray
            self.favoriteThreadsArray.reverse()
            self.tableView.reloadData()
        }
    }
    
    
    
    // MARK: - Button Touches
    
    @IBAction func segmentedControlTouched(_ sender: Any) {
        tableView.reloadData()
    }
    
    func touchedLogoutAction(alertAction: UIAlertAction) {
        try! Auth.auth().signOut()
        if Auth.auth().currentUser?.uid != nil {
        } else {
            signInButton.isHidden = false
            nameLabel.isHidden = true
            notSignedInWarningLabel.isHidden = false
            signInButtonView.isHidden = false
            notSignedInWarningLabel.isHidden = false
            signInButton.isHidden = false
            
        }
    }
    
    @IBAction func menuBarTapped(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "LogOut", style: .default, handler: touchedLogoutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(logoutAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
//    @objc func touchedMenuBarButton() {
//        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        let logoutAction = UIAlertAction(title: "LogOut", style: .default, handler: touchedLogoutAction)
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//
//        optionMenu.addAction(logoutAction)
//        optionMenu.addAction(cancelAction)
//
//        self.present(optionMenu, animated: true, completion: nil)
//    }
    
    
    // MARK: - Gesture Recognizer Methods
    
    @objc func handleProfileImageTap(gestureRecognizer:UIGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    

    
    func setupUIBar() {
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = .clear
        
        segmentedControl.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "DINCondensed-Bold", size: 18)!,
            NSAttributedStringKey.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        segmentedControl.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "DINCondensed-Bold", size: 18)!,
            NSAttributedStringKey.foregroundColor: UIColor(red: 49/255, green:12/255, blue:117/255, alpha: 1.0)
            ], for: .selected)
        
//        let buttonBar = UIView()
//        // This needs to be false since we are using auto layout constraints
//        buttonBar.translatesAutoresizingMaskIntoConstraints = false
//        buttonBar.backgroundColor = UIColor.orange
//
//        // Below view.addSubview(segmentedControl)
//        view.addSubview(buttonBar)
//
//        // Constrain the top of the button bar to the bottom of the segmented control
//        buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
//        buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
//        // Constrain the button bar to the left side of the segmented control
//        buttonBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor).isActive = true
//        // Constrain the button bar to the width of the segmented control divided by the number of segments
//        buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
//
//        // Above the PlaygroundPage.current.liveView = view statement at the bottom
//        segmentedControl.addTarget(responder, action: #selector(responder.segmentedControlValueChanged(_:)), for: UIControlEvents.valueChanged)
//
//        UIView.animate(withDuration: 0.3) {
//            buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
//        }
    }
    
    func setColors() {
        navigationController?.navigationBar.barTintColor = UIColor(red:15/255, green:166/255, blue:185/255, alpha:1.0)
        navigationController?.navigationBar.tintColor = UIColor(red: 49/255, green:12/255, blue:117/255, alpha: 1.0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segmentedControl.selectedSegmentIndex == 0) {
            if segue.identifier == "segueToThread" {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let currentCell = tableView.cellForRow(at: indexPath) as! ThreadTableViewCell
                    let targetController = segue.destination as! ThreadVC
                    targetController.threadID = currentCell.threadID
                }
            }
        }else{
            if segue.identifier == "segueToThread" {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let currentCell = tableView.cellForRow(at: indexPath) as! ThreadTableViewCell
                    let targetController = segue.destination as! ThreadVC
                    targetController.threadID = currentCell.threadID
                }
            }
        }
        
    }
    
}
