//
//  MissionViewController.swift
//  TAW
//
//  Created by Graphics on 2016/6/7.
//  Copyright © 2016年 Dark. All rights reserved.
//

import UIKit

class MissionViewController: UIViewController
{
    var OriginButtonCenter = CGPointZero
    var OriginButtonColor: UIColor?
    
    var qrScanner: QRScanner!
    
    @IBOutlet weak var QRViewBar: UIToolbar!
    @IBOutlet weak var messageLabel: UILabel!
    
    var IsStart: Bool = false;
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        qrScanner = QRScanner(view: view!,inputLabel:  messageLabel, QRBar: QRViewBar)
    }
    
    @IBAction func TestForQRCode(sender: AnyObject)
    {
        if !IsStart
        {
            IsStart = true
            qrScanner.Start(view)
        }
    }

    @IBAction func QRCodeStopEvent(sender: AnyObject)
    {
        
        IsStart = false
        qrScanner.Stop(view)
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
