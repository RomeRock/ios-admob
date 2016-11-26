//
//  IntersitialAdViewController.swift
//  iosAdMob
//
//  Created by Rome Rock on 11/24/16.
//  Copyright © 2016 Rome Rock. All rights reserved.
//

import UIKit

import GoogleMobileAds

class IntersitialAdViewController: UIViewController {

    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        createAndLoadInterstitial()
        showAdIntersitial()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-1943700858932247/3151384015")
        let request = GADRequest()
        // Request test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made.
        request.testDevices = [ kGADSimulatorID ]
        interstitial.load(request)
    }

    private func showAdIntersitial() {
        
        let alert = UIAlertController(title: "RomeRock", message: "Show Ad", preferredStyle: UIAlertControllerStyle.alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            if self.interstitial.isReady {
                self.interstitial.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
            }
        })
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
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
