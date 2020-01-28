//
//  ViewController.swift
//  myFrmaework
//
//  Created by Prasanth Podalakur on 08/04/19.
//  Copyright © 2019 Prasanth Podalakur. All rights reserved.
//

import UIKit
import CaptchaSDK
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
    }

    @IBAction func openCamVCButtonTapped(_ sender: Any) {


//        let vc = camVC()
//
//
//        let myVC = myCamVC()
//        let navigationVC = UINavigationController(rootViewController: myVC)
//        navigationVC.navigationBar.barTintColor = UIColor.lightGray
//        navigationVC.navigationBar.isHidden = true
//
//        self.present(navigationVC, animated: true, completion: nil)
        
        
//        let myBundle = Bundle(for: ViewController.self)
//        let myStoryboard = UIStoryboard(name: "mySDK", bundle: myBundle)
        
       sampleNSOBJ.openCameraView(self)
        
    }
    
}

