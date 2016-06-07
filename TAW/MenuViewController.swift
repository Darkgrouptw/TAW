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
        
        MissionButton.layer.cornerRadius = MissionButton.frame.width / 2
        MissionButton.clipsToBounds = true
        
        PetButton.layer.cornerRadius = PetButton.frame.width / 2
        PetButton.clipsToBounds = true
        
        AchievementButton.layer.cornerRadius = AchievementButton.frame.width / 2
        AchievementButton.clipsToBounds = true
        
        SettingButton.layer.cornerRadius = SettingButton.frame.width / 2
        SettingButton.clipsToBounds = true
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //print("123123123")
        let seg = segue as! AllMenuSegue
        seg.Mode = .Present
        seg.origin = selectedButton.center
        seg.circleColor = selectedButton.backgroundColor
        /*switch segue.identifier!
        {
        case "MenuToMission":
         
        default:
            break
        }*/
        /*
        if let controller = segue.destinationViewController as? MissionViewController
        {
            //print("123123123")
            controller.transitioningDelegate = self
            //print("123123123")
            controller.modalPresentationStyle = .Custom
        }*/
    }
    
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
    
    /*func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.origin = selectedButton.center
        transition.circleColor = selectedButton.backgroundColor!
        
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.origin = selectedButton.center
        transition.circleColor = selectedButton.backgroundColor!
        
        return transition
    }*/
}
