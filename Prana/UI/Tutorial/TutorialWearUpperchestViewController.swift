//
//  TutorialWearUpperchestViewController.swift
//  Prana
//
//  Created by Luccas on 4/3/19.
//  Copyright © 2019 Prana. All rights reserved.
//

import UIKit

class TutorialWearUpperchestViewController: UIViewController
{
    @IBOutlet weak var lowerback_btn: UIButton!
    @IBOutlet weak var uperchest_btn: UIButton?
    @IBOutlet weak var btn_next: UIButton!
    @IBOutlet weak var uperchestbtn: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        initView()
    }

    func initView() {
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "app-background")
        imageView.center = view.center
        view.insertSubview(imageView, at: 0)
        view.sendSubviewToBack(imageView)
        
        btn_next.titleLabel?.textAlignment = .center
    }

    @IBAction func onNext(_ sender: Any) {
        if PranaDeviceManager.shared.isConnected {
            gotoLiveGraph()
            return
        }
        
        gotoConnectViewController()
    }
      @IBAction func upper_btn(_ sender: Any) {
        uperchest_btn?.backgroundColor = UIColor(red: 43.0/255.0, green: 183.0/255.0, blue: 185.0/255.0, alpha: 1.0)

            lowerback_btn.backgroundColor = UIColor.lightGray
    //         uperchest_btn.backgroundColor = UIColor.green
        }
        
        @IBAction func lower_btn(_ sender: Any) {
            uperchest_btn?.backgroundColor = UIColor.lightGray

              lowerback_btn.backgroundColor = UIColor(red: 43.0/255.0, green: 183.0/255.0, blue: 185.0/255.0, alpha: 1.0)
        }
        
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func gotoLiveGraph() {
        let vc = Utils.getStoryboardWithIdentifier(name: "TutorialTraining", identifier: "LiveFeedViewController") as! LiveFeedViewController
        vc.isLowerBack = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoConnectViewController() {
        let firstVC = Utils.getStoryboardWithIdentifier(identifier: "ConnectViewController") as! ConnectViewController
        firstVC.isTutorial = false
        firstVC.completionHandler = { [unowned self] in
            self.gotoLiveGraph()
        }

        let navVC = UINavigationController(rootViewController: firstVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
}
