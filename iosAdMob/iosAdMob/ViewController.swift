//
//  ViewController.swift
//  iosAdMob
//
//  Created by Rome Rock on 11/24/16.
//  Copyright © 2016 Rome Rock. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var menuItem: UIBarButtonItem!
    var titleLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if self.revealViewController() != nil {
            menuItem.target = self.revealViewController()
            menuItem.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().panGestureRecognizer().delegate = self
        }
        titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.text = "MM: AdMob"
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        createAndLoadSmart()
        createAndLoadInterstitial()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func createAndLoadSmart() {
        if UIDevice.current.orientation == .portrait {
            bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        } else {
            bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerLandscape)
        }
        bannerView.adUnitID = "ca-app-pub-1943700858932247/7221656815"
        bannerView.rootViewController = self
        
        view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Layout constraints that align the banner view to the bottom center of the screen.
        view.addConstraint(NSLayoutConstraint(item: bannerView, attribute: .bottom,
                                              relatedBy: .equal, toItem: toolbar, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView, attribute: .centerX,
                                              relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
    }
    
    private func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-1943700858932247/3151384015")
        let request = GADRequest()
        // Request test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made.
        request.testDevices = [ kGADSimulatorID ]
        interstitial.load(request)
    }

    @IBAction func intersitialButtonPressed(_ sender: Any) {
        if self.interstitial.isReady {
            self.interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
            createAndLoadInterstitial()
        }
    }

}

