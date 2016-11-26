//
//  RewardedVideoViewController.swift
//  iosAdMob
//
//  Created by Rome Rock on 11/24/16.
//  Copyright © 2016 Rome Rock. All rights reserved.
//

import UIKit
import GoogleMobileAds

class RewardedVideoViewController: UIViewController, GADRewardBasedVideoAdDelegate {
    
    enum GameState: NSInteger {
        case notStarted
        case playing
        case paused
        case ended
    }
    
    /// Constant for coin rewards.
    let gameOverReward = 1
    
    /// Starting time for game counter.
    let gameLength = 10
    
    /// Number of coins the user has earned.
    var coinCount = 0
    
    /// Is an ad being loaded.
    var adRequestInProgress = false
    
    /// The reward-based video ad.
    var rewardBasedVideo: GADRewardBasedVideoAd?
    
    /// The countdown timer.
    var timer: Timer?
    
    /// The game counter.
    var counter = 10
    
    /// The state of the game.
    var gameState = GameState.notStarted
    
    /// The date that the timer was paused.
    var pauseDate: Date?
    
    /// The last fire date before a pause.
    var previousFireDate: Date?
    
    /// In-game text that indicates current counter value or game over state.
    @IBOutlet weak var gameText: UILabel!
    
    /// Button to restart game.
    @IBOutlet weak var playAgainButton: UIButton!
    
    /// Text that indicates current coin count.
    @IBOutlet weak var coinCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        rewardBasedVideo = GADRewardBasedVideoAd.sharedInstance()
        rewardBasedVideo?.delegate = self
        coinCountLabel.text = "Coins: \(self.coinCount)"
        
        // Pause game when application is backgrounded.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(RewardedVideoViewController.applicationDidEnterBackground(_:)),
                                               name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
        // Resume game when application is returned to foreground.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(RewardedVideoViewController.applicationDidBecomeActive(_:)),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        startNewGame()

    }

    fileprivate func startNewGame() {
        gameState = .playing
        counter = gameLength
        playAgainButton.isHidden = true
        
        if !adRequestInProgress && rewardBasedVideo?.isReady == false {
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            rewardBasedVideo?.load(request,
                                   withAdUnitID: "ca-app-pub-1943700858932247/2394504419")
            adRequestInProgress = true
        }
        
        gameText.text = String(counter)
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector:#selector(RewardedVideoViewController.timerFireMethod(_:)),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func applicationDidEnterBackground(_ notification: Notification) {
        // Pause the game if it is currently playing.
        if gameState != .playing {
            return
        }
        gameState = .paused
        
        // Record the relevant pause times.
        pauseDate = Date()
        previousFireDate = timer?.fireDate
        
        // Prevent the timer from firing while app is in background.
        timer?.fireDate = Date.distantFuture
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        // Resume the game if it is currently paused.
        if gameState != .paused {
            return
        }
        gameState = .playing
        
        // Calculate amount of time the app was paused.
        let pauseTime = (pauseDate?.timeIntervalSinceNow)! * -1
        
        // Set the timer to start firing again.
        timer?.fireDate = (previousFireDate?.addingTimeInterval(pauseTime))!
    }
    
    func timerFireMethod(_ timer: Timer) {
        counter -= 1
        if counter > 0 {
            gameText.text = String(counter)
        } else {
            endGame()
        }
    }
    
    fileprivate func earnCoins(_ coins: NSInteger) {
        coinCount += coins
        coinCountLabel.text = "Coins: \(self.coinCount)"
    }
    
    fileprivate func endGame() {
        gameState = .ended
        gameText.text = "Game over!"
        playAgainButton.isHidden = false
        timer?.invalidate()
        timer = nil
        earnCoins(gameOverReward)
    }
    
    // MARK: Button actions
    @IBAction func playAgain(_ sender: AnyObject) {
        if rewardBasedVideo?.isReady == true {
            rewardBasedVideo?.present(fromRootViewController: self)
        } else {
            /*UIAlertView(title: "Reward based video not ready",
                        message: "The reward based video didn't finish loading or failed to load",
                        delegate: self,
                        cancelButtonTitle: "Drat").show()*/
            let alert = UIAlertController(title: "Reward based video not ready", message: "The reward based video didn't finish loading or failed to load", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertAction = UIAlertAction(title: "Drat", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                self.startNewGame()
            })
            
            alert.addAction(alertAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: GADRewardBasedVideoAdDelegate implementation
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        adRequestInProgress = false
        print("Reward based video ad failed to load: \(error.localizedDescription)")
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        adRequestInProgress = false
        print("Reward based video ad is received.")
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        //earnCoins(NSInteger(reward.amount))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
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
