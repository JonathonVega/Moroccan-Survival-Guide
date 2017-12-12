//
//  CreateThreadVC.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 12/12/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit

class CreateThreadVC: UIViewController {

    @IBOutlet weak var subjectLabel: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addImage(_ sender: Any) {
    }
    
    @IBAction func createThread(_ sender: Any) {
    }
    
    @IBAction func cancelThreadCreation(_ sender: Any) {
    }
}
