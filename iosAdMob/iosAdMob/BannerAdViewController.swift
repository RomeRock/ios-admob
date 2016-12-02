//
//  BannerAdViewController.swift
//  iosAdMob
//
//  Created by Rome Rock on 11/24/16.
//  Copyright © 2016 Rome Rock. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Crashlytics

class BannerAdViewController: UIViewController {

    @IBOutlet var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView.adUnitID = "ca-app-pub-1943700858932247/7221656815"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
        Crashlytics.sharedInstance().crash()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
