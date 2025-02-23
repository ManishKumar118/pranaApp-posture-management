//
//  TutorialVisualViewController.swift
//  Prana
//
//  Created by Luccas on 4/4/19.
//  Copyright © 2019 Prana. All rights reserved.
//

import UIKit

class TutorialVisualViewController: UIViewController {
    @IBOutlet weak var buzzer_btn: UIButton!
     
     @IBOutlet weak var visual_btn: UIButton!
    @IBOutlet weak var btn_next: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let nav = self.navigationController {
            nav.viewControllers.remove(at: nav.viewControllers.count - 2)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(onLandscapeViewControllerDismiss), name: .landscapeViewControllerDidDismiss, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceOrientationChange), name: .deviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onVisualViewControllerEnd), name: .visualViewControllerEndSession, object: nil)

        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = true
        
        initView()
    }
    @IBAction func visual_action(_ sender: Any) {
         buzzer_btn.backgroundColor = UIColor.lightGray

                       visual_btn.backgroundColor = UIColor(red: 43.0/255.0, green: 183.0/255.0, blue: 185.0/255.0, alpha: 1.0)
    }
     @IBAction func buzzer_btn(_ sender: Any) {
            visual_btn.backgroundColor = UIColor.lightGray

                                 buzzer_btn.backgroundColor = UIColor(red: 43.0/255.0, green: 183.0/255.0, blue: 185.0/255.0, alpha: 1.0)
        }
        @objc func onVisualViewControllerEnd() {
    //        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            let vc = Utils.getStoryboardWithIdentifier(name:"TutorialTraining", identifier: "TutorialBuzzerViewController")
            self.navigationController?.pushViewController(vc, animated: false)
        }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
//    override var shouldAutorotate: Bool {
//        return true
//    }
    
    @objc func onLandscapeViewControllerDismiss() {
//        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
//    @objc func onVisualViewControllerEnd() {
////        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
//        let vc = Utils.getStoryboardWithIdentifier(name:"TutorialTraining", identifier: "TutorialBuzzerViewController")
//        self.navigationController?.pushViewController(vc, animated: false)
//    }
    
    @objc func onDeviceOrientationChange() {
//        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func initView() {
        let background = UIImage(named: "app-background")
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.insertSubview(imageView, at: 0)
        view.sendSubviewToBack(imageView)
        
        btn_next.titleLabel?.textAlignment = .center
    }

    @IBAction func onNext(_ sender: Any) {
        if PranaDeviceManager.shared.isConnected {
            gotoVisualTraining()
            return
        }
        
        gotoConnectViewController()
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func gotoVisualTraining() {
        let vc = Utils.getStoryboardWithIdentifier(name: "VisualTraining", identifier: "VisualTrainingViewController") as! VisualTrainingViewController
        vc.isTutorial = true
        vc.sessionKind = 0
        vc.sessionWearing = 0
        vc.sessionDuration = 1
        vc.whichPattern = 0
        vc.subPattern = 0
        vc.skipCalibration = 0
        vc.maxSubPattern = 34
        vc.patternTitle = patternNames[vc.whichPattern].0
        //        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, as: .landscape, curtainColor: .white)
        //        self.present(vc, animated: false, completion: nil)
    }
    
    func gotoConnectViewController() {
        let firstVC = Utils.getStoryboardWithIdentifier(identifier: "ConnectViewController") as! ConnectViewController
        firstVC.isTutorial = false
        firstVC.completionHandler = { [unowned self] in
            self.gotoVisualTraining()
        }
        
        let navVC = UINavigationController(rootViewController: firstVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
}
