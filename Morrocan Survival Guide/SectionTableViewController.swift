//
//  SectionTableViewController.swift
//  Morrocan Survival Guide
//
//  Created by Jonathon F Vega on 8/27/16.
//  Copyright © 2016 Jonathon Vega. All rights reserved.
//

import UIKit

class SectionTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red:11/255, green:193/255, blue:76/255, alpha:1.0)
        navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Topics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as! SectionsTableViewCell
        
        cell.topic.text = Topics.getStringFromEnum((indexPath as NSIndexPath).row)
        return cell

    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "translations" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let section = Topics.getStringFromEnum((indexPath as NSIndexPath).row)
                let targetController = segue.destination as! DetailsTableViewController
                targetController.tableTitle = section
                
                targetController.wordList = Topics.getWords(section)

            }
        }
    }
    
}
