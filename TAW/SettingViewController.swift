//
//  SettingViewController.swift
//  TAW
//
//  Created by Graphics on 2016/6/8.
//  Copyright © 2016年 Dark. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController
{
    var OriginButtonCenter = CGPointZero
    var OriginButtonColor: UIColor?
    
    @IBOutlet weak var Photo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Photo.layer.cornerRadius = Photo.frame.height * 0.1
        Photo.clipsToBounds = true
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
