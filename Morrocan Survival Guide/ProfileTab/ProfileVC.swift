//
//  ProfileVC.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 9/11/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var signInButton: UIBarButtonItem!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileUsername: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func questionsAskedListButton(_ sender: UIButton) {
    }
    
    @IBAction func changeProfilePassword(_ sender: UIButton) {
    }

}
