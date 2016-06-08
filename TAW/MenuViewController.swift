//
//  MenuViewController.swift
//  TAW
//
//  Created by Graphics on 2016/6/5.
//  Copyright © 2016年 Dark. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    //let transition = PopAnimator()
    @IBOutlet weak var MissionButton: UIButton!
    @IBOutlet weak var PetButton: UIButton!
    @IBOutlet weak var AchievementButton: UIButton!
    @IBOutlet weak var SettingButton: UIButton!
    
    
    var selectedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("To Menu View Controller !!")
        
        // 讓按鈕變成圓的
        MissionButton.layer.cornerRadius = MissionButton.frame.width / 2
        MissionButton.clipsToBounds = true
        
        PetButton.layer.cornerRadius = PetButton.frame.width / 2
        PetButton.clipsToBounds = true
        
        AchievementButton.layer.cornerRadius = AchievementButton.frame.width / 2
        AchievementButton.clipsToBounds = true
        
        SettingButton.layer.cornerRadius = SettingButton.frame.width / 2
        SettingButton.clipsToBounds = true
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let seg = segue as! AllMenuSegue
        seg.Mode = .Present
        seg.origin = selectedButton.center
        seg.circleColor = selectedButton.backgroundColor
        
        switch segue.identifier!
        {
        case "MenuToMission":
            let segVC = segue.destinationViewController as! MissionViewController
            segVC.OriginButtonCenter = self.selectedButton.center
            segVC.OriginButtonColor = self.selectedButton.backgroundColor
        case "MenuToPet":
            let segVC = segue.destinationViewController as! PetViewController
            segVC.OriginButtonCenter = self.selectedButton.center
            segVC.OriginButtonColor = self.selectedButton.backgroundColor
        case "MenuToAchievement":
            let segVC = segue.destinationViewController as! AchievementViewController
            segVC.OriginButtonCenter = self.selectedButton.center
            segVC.OriginButtonColor = self.selectedButton.backgroundColor
        case "MenuToSetting":
            let segVC = segue.destinationViewController as! SettingViewController
            segVC.OriginButtonCenter = self.selectedButton.center
            segVC.OriginButtonColor = self.selectedButton.backgroundColor
        default:
            break
        }
    }
    
    // 要讓上面那一條不見
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func handleButton(sender: AnyObject)
    {
        let Button = sender as! UIButton
        self.selectedButton = Button
    }
}
