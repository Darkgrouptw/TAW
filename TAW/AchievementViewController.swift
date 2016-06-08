//
//  AchievementViewController.swift
//  TAW
//
//  Created by Graphics on 2016/6/8.
//  Copyright © 2016年 Dark. All rights reserved.
//

import UIKit

class AchievementViewController: UIViewController
{
    var OriginButtonCenter = CGPointZero
    var OriginButtonColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let seg = segue as! AllMenuSegue
        seg.Mode = .Dismiss
        seg.origin = OriginButtonCenter
        seg.circleColor = OriginButtonColor
    }
}
