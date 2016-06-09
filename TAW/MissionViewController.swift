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
    
    var IsStart: Bool = false
    
    // Mission url
    var MissionURL:NSURL = NSURL(string: "http://140.118.175.73/TAW/Missions/")!
    
    // 看有沒有上一個任務還沒完成
    var LastData: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    // Get All Data
    var DataFromServer: Array<String>!
    var ButtonFromData: Array<UIButton>!
    var Timer: NSTimer!
    var TimerIndex: Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        qrScanner = QRScanner(view: view!,inputLabel:  messageLabel, QRBar: QRViewBar)
        
        
        let lastMission: String? = LastData.stringForKey("LastMission")
        if(lastMission == nil)
        {
            // 代表上一個任務沒有執行果
            let request = NSMutableURLRequest(URL: MissionURL)
            request.HTTPMethod = "GET"
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                guard error == nil && data != nil else {
                    LoginViewController.AlertMessageShow("網路異常，請重新開始", targetViewController: self)
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                    // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    LoginViewController.AlertMessageShow("網路異常，請重新開始", targetViewController: self )
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                self.OperationToDataFromServer(responseString as! String, type: 0)
                
            }
            task.resume()

        }
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
    
    
    // 開始要動態的產生， UILabel，讓他有泡泡飄上來的感覺
    func DynamicAddMenuButton()
    {
        print("123")
        if(TimerIndex < DataFromServer.count)
        {
            let TempButton = UIButton(frame: ItemRect())
            TempButton.backgroundColor = UIColor.greenColor()
            TempButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            TempButton.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
            TempButton.setTitle(DataFromServer[TimerIndex], forState: .Normal)
            self.view.addSubview(TempButton)
            ButtonFromData.append(TempButton)
            TimerIndex += 1
        }
        else
        {
            TimerIndex = 0
            Timer.invalidate()
        }
    }
    
    
    // 處理從 Server 來的資料
    func OperationToDataFromServer(str: String, type: Int)
    {
        print("=========== Data From Server ===========")
        print(str)
        DataFromServer = str.componentsSeparatedByString("\n")
        DataFromServer.removeLast()         // 把最後的空白丟掉
        print(DataFromServer.count)
        print("========================================")
        
        switch type {
        case 0:
            // 顯示 Menu
            Timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(DynamicAddMenuButton), userInfo: nil, repeats: false)
        default:
            break
        }
        
        
    }
    
    func ItemRect() -> CGRect
    {
        let screenWidth = self.view.frame.size.width
        //let
        
        return CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height / 2, screenWidth, 100)
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
