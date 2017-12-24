//
//  RefrencesTableVC.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 9/9/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit

class ReferencesTableVC: UITableViewController {

    let ReferenceList = ["Terminology", "Customs", "Laws", "Emergency Contacts"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return ReferenceList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = ReferenceList[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "toTerms", sender: self)
        } else {
            self.performSegue(withIdentifier: "toReference", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReference" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let reference = ReferenceList[indexPath.row]
                let targetController = segue.destination as! ReferenceInfoTableVC
                targetController.tableTitle = reference
            }
        } else if segue.identifier == "toTerms" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
            }
        }
    }

}
