//
//  SettingsView.swift
//  TwerkApp
//
//  Created by mac on 11.03.18.
//  Copyright © 2018 Filipp. All rights reserved.
//

import UIKit

class SettingsView: UIViewController {
    let defaults = UserDefaults.standard
    
    var Game: TwerkGame? = nil
    
    @IBOutlet weak var SoundButton: UIButton!
    @IBOutlet weak var VibrationButton: UIButton!
    @IBOutlet weak var CoinLabel: UILabel!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAllVisibleInfo()
        // Do any additional setup after loading the view.
    }
    
    func updateAllVisibleInfo() {
        if let game = Game {
            if game.ifSound {
                SoundButton.setImage(#imageLiteral(resourceName: "sound-up"), for: .normal)
            } else {
                SoundButton.setImage(#imageLiteral(resourceName: "sound"), for: .normal)
            }
            
            if game.ifVibration {
                VibrationButton.setImage(#imageLiteral(resourceName: "vibration-up"), for: .normal)
            } else {
                VibrationButton.setImage(#imageLiteral(resourceName: "vibration"), for: .normal)
            }
            
            CoinLabel.text = String(game.coins)
        } else {
            NSLog ("FKDBG some problem with Game on settings view")
        }
    }
    
    @IBAction func SoundButtonClick(_ sender: UIButton) {
        if let game = Game {
            game.changeSoundSettings()
        } else {
            NSLog ("FKDBG some problem with Game on settings view")
        }
        updateAllVisibleInfo()
    }
    
    @IBAction func VibrationButtonClick(_ sender: UIButton) {
        if let game = Game {
            game.changeVibrationSettings()
        } else {
            NSLog ("FKDBG some problem with Game on settings view")
        }
        updateAllVisibleInfo()
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
        NSLog("FKDBG хуйня с prepare for segue")
        abort ()
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
