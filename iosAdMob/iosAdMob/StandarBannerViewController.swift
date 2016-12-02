//
//  StandarBannerViewController.swift
//  iosAdMob
//
//  Created by Rome Rock on 12/1/16.
//  Copyright © 2016 Rome Rock. All rights reserved.
//

import UIKit

import GoogleMobileAds

class StandarBannerViewController: UIViewController {

    var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-1943700858932247/7221656815"
        bannerView.rootViewController = self
        
        view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Layout constraints that align the banner view to the bottom center of the screen.
        view.addConstraint(NSLayoutConstraint(item: bannerView, attribute: .bottom,
                                              relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView, attribute: .centerX,
                                              relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
        
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
