//
//  ReferenceInfoTableVC.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 9/10/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit

class ReferenceInfoTableVC: UITableViewController {

    var tableTitle = ""
    var cultureTipProvider: CultureTipProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cultureTipProvider = CultureTipProvider()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44  
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
        if (tableTitle == "Customs") {
            return (cultureTipProvider?.customs.count)!
        } else if (tableTitle == "Commodities") {
            return (cultureTipProvider?.commodity.count)!
        } else if (tableTitle == "Nationalities") {
            return (cultureTipProvider?.nationalities.count)!
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.selectionStyle = .none
        if (tableTitle == "Customs") {
            cell.textLabel?.text = cultureTipProvider?.customs[indexPath.row]
        }else if(tableTitle == "Commodities") {
            cell.textLabel?.text = cultureTipProvider?.commodity[indexPath.row]
        } else if(tableTitle == "Nationalities") {
            cell.textLabel?.text = cultureTipProvider?.nationalities[indexPath.row]
        }
        
        return cell
    }

}
