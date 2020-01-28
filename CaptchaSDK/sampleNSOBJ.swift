//
//  sampleNSOBJ.swift
//  CaptchaSDK
//
//  Created by Prasanth Podalakur on 08/04/19.
//  Copyright © 2019 Prasanth Podalakur. All rights reserved.
//

import UIKit
  open class sampleNSOBJ: NSObject {
    open class func openCameraView(_ viewcontroller: UIViewController) {
       
        let bundle = Bundle(identifier: "com.vsoft.CaptchaSDK")
        let myStoryboard = UIStoryboard(name: "mySDK", bundle: bundle)
        let cam = myStoryboard.instantiateViewController(withIdentifier: "myCamVC") as! myCamVC
        let navVC = UINavigationController(rootViewController: cam)
        viewcontroller.present(navVC, animated: true, completion: nil)
    }

}
