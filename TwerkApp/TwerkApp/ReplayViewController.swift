//
//  ReplayViewController.swift
//  TwerkApp
//
//  Created by mac on 11.03.18.
//  Copyright © 2018 Filipp. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ReplayViewController: UIViewController, GADRewardBasedVideoAdDelegate {
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        NSLog("reward!")
    }
    
    var Game: TwerkGame? = nil
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func ContinuePlayingPushed(_ sender: UIButton) {
        if let game = Game {
            if GADRewardBasedVideoAd.sharedInstance().isReady == true {
                GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
            } else {
                NSLog("no GAD")
            }
            game.ifShowReplay = false
            game.ifGame = true
        } else {
            print("Some troubles in ContinuePlayingPushed")
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSLog("replay viewDidLoad")
        GADRewardBasedVideoAd.sharedInstance().delegate = self as! GADRewardBasedVideoAdDelegate
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GameViewController {
            vc.Game = Game
            return
        }
        if let vc = segue.destination as? GameEndViewController {
            vc.Game = Game
            return
        }
        NSLog("Какая-то хуйня с переходом из ReplayViewController по Segue")
        abort()
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        if let game = Game {
            game.ifShowReplay = false
            game.ifGame = true
            performSegue(withIdentifier: "fromReplayToGame", sender: nil)
        } else {
            NSLog("some fucking trouble with segue")
            performSegue(withIdentifier: "fromReplayToGameEnd", sender: nil)
        }
        
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
