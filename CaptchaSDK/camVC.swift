//
//  camVC.swift
//  CaptchaSDK
//
//  Created by Prasanth Podalakur on 08/04/19.
//  Copyright © 2019 Prasanth Podalakur. All rights reserved.
//

import UIKit

public class camVC: UIViewController {

//    @IBOutlet  var mainView: UIView?
    @IBOutlet var annotationOptionsView: UIView!
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        var bundle : Bundle? = nil
        let libBundle = Bundle(for: self.classForCoder)
        if let bundleURL = libBundle.url(forResource: "CaptchaSDK", withExtension: "bundle") {
            if let resourceBundle = Bundle.init(url: bundleURL) {
                bundle = resourceBundle
            } else {
                assertionFailure("Could not load the resource bundle")
            }
        } else {
            bundle = libBundle
        }
        let nib  = UINib(nibName: "camVC", bundle: bundle)
        self.view = (nib.instantiate(withOwner: self, options: nil).first as! UIView)
        
//        view!.frame = boun
        
//        addSubview(view!)
//        let vc = UIView(frame: UIScreen.main.bounds)
//        vc.backgroundColor = .red
//        self.view.addSubview(vc)
//        mainView = UIView()
//        vc.addSubview(mainView!)
//        vc.bringSubviewToFront(mainView!)
        print("Is annotation Options view nil? \(self.annotationOptionsView != nil)")
        self.view.addSubview(self.annotationOptionsView)
        
    }



}
