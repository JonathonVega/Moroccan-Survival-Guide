//
//  DetailViewController.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 9/5/16.
//  Copyright © 2016 Jonathon Vega. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit
import AudioToolbox

class DetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var detailWordList = [[String]]()
    let viewDetails = [UIView]()
    var currentWord: String = ""
    var player: AVAudioPlayer?
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.isPagingEnabled = true
        setupScrollView()
        scrollView.setContentOffset(currentTranslation(), animated: false)
    }
    
    // MARK: - Views Setup
    
    func setupScrollView() {
        
        let endNum = detailWordList.count - 1
        var totalWidth:CGFloat = 0
        
        for index in 0...endNum {

            let newView = setupSubview(totalWidth)
            
            addEnglishTrans(index, currentView: newView)
            addArabicTrans(index, currentView: newView)
            addVoiceButton(arabicIndex: index, currentView: newView)
            scrollView.addSubview(newView)
            totalWidth += scrollView.bounds.size.width
        }
        scrollView.contentSize = CGSize(width: totalWidth, height: scrollView.bounds.size.height)
    }
    
    func setupSubview(_ totalWidth: CGFloat) -> UIView {
        let newView = UIView()
        newView.frame.size.width = scrollView.frame.size.width - 60
        newView.frame.size.height = scrollView.frame.size.height - 100
        newView.center = CGPoint(x: scrollView.frame.size.width / 2 + totalWidth, y: scrollView.frame.size.height / 2);

        newView.backgroundColor = UIColor.white
        newView.layer.shadowOpacity = 0.5
        return newView
    }
    
    // Func for when going directly to the word that was clicked from the DetailsTableView
    func currentTranslation() -> CGPoint{
        var x = 0
        for i in detailWordList {
            if (i[0] == currentWord) {
                let y = (scrollView.contentSize.width / CGFloat(detailWordList.count)) * CGFloat(x)
                let curPoint: CGPoint = CGPoint(x: y, y: 0)
                return curPoint
            }
            x += 1
        }
        return CGPoint(x: 0, y: 0)
    }
    
    // MARK: - Adding Labels and Buttons
    
    func addEnglishTrans(_ index: Int, currentView: UIView) {
        let enWord = UILabel()
        enWord.backgroundColor = UIColor.white
        enWord.frame.size = CGSize(width: 150, height: 40)
        enWord.center = CGPoint(x: currentView.frame.size.width / 2, y: 75)
        enWord.textAlignment = NSTextAlignment.center
        enWord.text = detailWordList[index][0]
        enWord.font = UIFont(name: "Helvetica" , size: 30)
        enWord.adjustsFontSizeToFitWidth = true
        currentView.addSubview(enWord)
    }
    
    func addArabicTrans(_ index: Int, currentView: UIView) {
        let arWord = UILabel()
        arWord.backgroundColor = UIColor.white
        arWord.frame.size = CGSize(width: 150, height: 40)
        arWord.center = CGPoint(x: currentView.frame.size.width / 2, y: 150)
        arWord.textAlignment = NSTextAlignment.center
        arWord.text = detailWordList[index][1]
        arWord.font = UIFont(name: "Helvetica" , size: 30)
        arWord.textColor = UIColor(red: 167/255, green: 161/255, blue: 164/255, alpha: 1.0)
        arWord.adjustsFontSizeToFitWidth = true
        currentView.addSubview(arWord)
    }
    
    
    
    
    func addVoiceButton(arabicIndex: Int, currentView: UIView) {
        let voiceButton = UIButton()
        voiceButton.frame.size = CGSize(width: 100, height: 100)
        voiceButton.center = CGPoint(x: currentView.frame.size.width / 2, y: currentView.center.y + CGFloat(30))
        let image = UIImage(named: "audio-volume.png")
        voiceButton.setImage(image, for: .normal)
        voiceButton.addTarget(self, action: #selector(voiceAction), for: .touchUpInside)
        
        voiceButton.tag = arabicIndex
        
        currentView.addSubview(voiceButton)
    }
    
    // MARK: - Adding Sound
    
    func voiceAction(sender: UIButton!) {
        let index = sender.tag
        let arabicWord = detailWordList[index][1]
        let voiceURL: URL
        
        if let path = Bundle.main.path(forResource: getSoundString(arWord: arabicWord), ofType: "m4a"){
            voiceURL = URL(fileURLWithPath: path)
        } else {
            let path = Bundle.main.path(forResource: "Silence", ofType: "m4a")!
            voiceURL = URL(fileURLWithPath: path)
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: voiceURL)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func getSoundString(arWord: String) -> String {
        var resourceName: String = ""
        if arWord.characters.contains("/") {
            for i in arWord.characters {
                if i == "/" {
                    resourceName += ":"
                } else {
                    resourceName += String(i)
                }
            }
            
            return resourceName
        } else {
            return arWord
        }
    }
    
}







