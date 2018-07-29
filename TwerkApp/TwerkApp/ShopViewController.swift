//
//  SettingsView.swift
//  TwerkApp
//
//  Created by mac on 11.03.18.
//  Copyright © 2018 Filipp. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {
    let defaults = UserDefaults.standard
    
    var Game: TwerkGame? = nil
    
    @IBOutlet weak var NickiBtn: UIButton!
    @IBOutlet weak var IggiBtn: UIButton!
    @IBOutlet weak var KimBtn: UIButton!
    @IBOutlet weak var BeyonceBtn: UIButton!
    @IBOutlet weak var MiaBtn: UIButton!
    @IBOutlet weak var TrumpBtn: UIButton!
    
    @IBAction func NickiTouched(_ sender: Any) {
        if let game = Game {
            game.changeSkinSettings(toValue: SKIN_NICKI_NUM)
        }
        updateButtonLabels()
    }
    
    @IBAction func IggiTouched(_ sender: Any) {
        if let game = Game {
            game.changeSkinSettings(toValue: SKIN_IGGI_NUM)
        }
        updateButtonLabels()
    }
    @IBAction func KimTouched(_ sender: Any) {
        if let game = Game {
            game.changeSkinSettings(toValue: SKIN_KIM_NUM)
        }
        updateButtonLabels()
    }
    @IBAction func MiaTouched(_ sender: Any) {
        if let game = Game {
            game.changeSkinSettings(toValue: SKIN_MIA_NUM)
        }
        updateButtonLabels()
    }
    
    @IBAction func TrumpTouched(_ sender: Any) {
        if let game = Game {
            game.changeSkinSettings(toValue: SKIN_TRUMP_NUM)
        }
        updateButtonLabels()
    }
    
    @IBAction func BeyonceTouched(_ sender: Any) {
        if let game = Game {
            game.changeSkinSettings(toValue: SKIN_BEYONCE_NUM)
        }
        updateButtonLabels()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAllVisibleInfo()
        // Do any additional setup after loading the view.
    }
    
    fileprivate func updateAllVisibleInfo() {
        updateButtonLabels()
    }
    
    fileprivate func updateButtonLabels() {
        KimBtn.setTitleColor(UIColor.white, for: .normal)
        MiaBtn.setTitleColor(UIColor.white, for: .normal)
        IggiBtn.setTitleColor(UIColor.white, for: .normal)
        NickiBtn.setTitleColor(UIColor.white, for: .normal)
        TrumpBtn.setTitleColor(UIColor.white, for: .normal)
        BeyonceBtn.setTitleColor(UIColor.white, for: .normal)
        
        if let game = Game {
            switch game.personNum {
            case SKIN_IGGI_NUM:
                IggiBtn.setTitleColor(UIColor.red, for: .normal)
            case SKIN_MIA_NUM:
                MiaBtn.setTitleColor(UIColor.red, for: .normal)
            case SKIN_BEYONCE_NUM:
                BeyonceBtn.setTitleColor(UIColor.red, for: .normal)
            case SKIN_TRUMP_NUM:
                TrumpBtn.setTitleColor(UIColor.red, for: .normal)
            case SKIN_NICKI_NUM:
                NickiBtn.setTitleColor(UIColor.red, for: .normal)
            case SKIN_KIM_NUM:
                KimBtn.setTitleColor(UIColor.red, for: .normal)
            default:
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let game = Game {
            if let vc = segue.destination as? GameViewController {
                vc.Game = game
                return
            }
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
