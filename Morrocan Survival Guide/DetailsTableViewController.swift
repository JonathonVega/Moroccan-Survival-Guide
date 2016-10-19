//
//  DetailsTableViewController.swift
//  Morrocan Survival Guide
//
//  Created by Jonathon F Vega on 8/28/16.
//  Copyright © 2016 Jonathon Vega. All rights reserved.
//

import UIKit

class DetailsTableViewController: UITableViewController {
    
    var tableTitle = ""
    var wordList = [[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = tableTitle
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordList[0].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailsTableViewCell
        
        cell.enTranslation.text = wordList[0][(indexPath as NSIndexPath).row]
        cell.arTranslation.text = wordList[1][(indexPath as NSIndexPath).row]
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let targetController = segue.destination as! DetailViewController
                targetController.detailWordList = wordList
                targetController.currentWord = wordList[0][(indexPath as NSIndexPath).row]
            }
            
        }
    }
    
}
