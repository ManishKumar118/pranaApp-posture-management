//
//  TutorialBuzzerViewController.swift
//  Prana
//
//  Created by Luccas on 4/4/19.
//  Copyright © 2019 Prana. All rights reserved.
//

import UIKit

class TutorialBuzzerViewController: UIViewController {
    @IBOutlet weak var buzzer_btn: UIButton!
      @IBOutlet weak var visual_btn: UIButton!
    @IBOutlet weak var btn_next: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        self.navigationController?.isNavigationBarHidden = true
        
        initView()
    }
    
    func initView() {
        btn_next.titleLabel?.textAlignment = .center
    }
    @IBAction func buzzer_btn(_ sender: Any) {
          buzzer_btn.backgroundColor = UIColor.lightGray

          visual_btn.backgroundColor = UIColor(red: 43.0/255.0, green: 183.0/255.0, blue: 185.0/255.0, alpha: 1.0)
      }
      
      @IBAction func visual_btn(_ sender: Any) {
          visual_btn.backgroundColor = UIColor.lightGray

                                  buzzer_btn.backgroundColor = UIColor(red: 43.0/255.0, green: 183.0/255.0, blue: 185.0/255.0, alpha: 1.0)
      }
    @IBAction func onNext(_ sender: Any) {
        if PranaDeviceManager.shared.isConnected {
            gotoBuzzerTraining()
            return
        }
        
        gotoConnectViewController()
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func gotoBuzzerTraining() {
        let vc = Utils.getStoryboardWithIdentifier(name: "BuzzerTraining", identifier:"BuzzerTrainingViewController") as! BuzzerTrainingViewController
        vc.isTutorial = true
        vc.sessionKind = 0
        vc.sessionWearing = 0
        vc.sessionDuration = 1
        vc.whichPattern = 0
        vc.subPattern = 5
        vc.startSubPattern = 5
        vc.maxSubPattern = 8
        vc.patternTitle = patternNames[vc.whichPattern].0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoConnectViewController() {
        let firstVC = Utils.getStoryboardWithIdentifier(identifier: "ConnectViewController") as! ConnectViewController
        firstVC.isTutorial = false
        firstVC.completionHandler = { [unowned self] in
            self.gotoBuzzerTraining()
        }
        
        let navVC = UINavigationController(rootViewController: firstVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
}
